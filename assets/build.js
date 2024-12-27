const esbuild = require("esbuild")
const sveltePlugin = require("esbuild-svelte")
const importGlobPlugin = require("esbuild-plugin-import-glob").default
const sveltePreprocess = require("svelte-preprocess")

const args = process.argv.slice(2)
const watch = args.includes("--watch")
const deploy = args.includes("--deploy")

let optsClient = {
    entryPoints: ["js/app.js"],
    bundle: true,
    minify: deploy,
    target: "es2017",
    conditions: ["svelte", "browser"],
    outdir: "../priv/static/assets",
    logLevel: "info",
    sourcemap: watch ? "inline" : false,
    tsconfig: "./tsconfig.json",
    plugins: [
        importGlobPlugin(),
        sveltePlugin({
            preprocess: sveltePreprocess(),
            compilerOptions: {dev: !deploy, hydratable: true, css: "injected"},
        }),
    ],
}

let optsServer = {
    entryPoints: ["js/server.js"],
    platform: "neutral",
    bundle: true,
    minify: false,
    target: "esnext",
    conditions: ["svelte"],
    format: "esm",
    outdir: "../priv/svelte",
    logLevel: "info",
    sourcemap: watch ? "inline" : false,
    tsconfig: "./tsconfig.json",
    plugins: [
        importGlobPlugin(),
        sveltePlugin({
            preprocess: sveltePreprocess(),
            compilerOptions: {dev: !deploy, hydratable: true, generate: "ssr"},
        }),
    ],
    mainFields: ["module", "main"],
    resolveExtensions: [".js", ".mjs", ".ts", ".json"],
    footer: {
        js: "globalThis.render = render;",
    },

}

if (watch) {
    esbuild
        .context(optsClient)
        .then(ctx => ctx.watch())
        .catch(_error => process.exit(1))

    esbuild
        .context(optsServer)
        .then(ctx => ctx.watch())
        .catch(_error => process.exit(1))
} else {
    esbuild.build(optsClient)
    esbuild.build(optsServer)
}
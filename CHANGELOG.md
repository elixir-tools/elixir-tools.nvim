# CHANGELOG

## Unreleased

## [0.10.1](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.10.0...v0.10.1) (2023-10-02)


### Bug Fixes

* receive correct json responses from curl ([#173](https://github.com/elixir-tools/elixir-tools.nvim/issues/173)) ([99d2a27](https://github.com/elixir-tools/elixir-tools.nvim/commit/99d2a27baf869668d114616b5b95a6f6ef425a79))

## [0.10.0](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.9.4...v0.10.0) (2023-10-02)


### Features

* **nextls:** init options ([#174](https://github.com/elixir-tools/elixir-tools.nvim/issues/174)) ([68a6433](https://github.com/elixir-tools/elixir-tools.nvim/commit/68a6433df667046cd24ccd16068d16322988b929))

## [0.9.4](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.9.3...v0.9.4) (2023-09-14)


### Bug Fixes

* **nextls:** correctly find root dir ([d89d774](https://github.com/elixir-tools/elixir-tools.nvim/commit/d89d774a5e0abe1ec78541b0d4b9713e156ecaa7))

## [0.9.3](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.9.2...v0.9.3) (2023-09-14)


### Bug Fixes

* correct logic for identifying default cmd([#169](https://github.com/elixir-tools/elixir-tools.nvim/issues/169)) ([252c3e5](https://github.com/elixir-tools/elixir-tools.nvim/commit/252c3e50d69f534bb6792b7870a5a91fdcefb3c6))

## [0.9.2](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.9.1...v0.9.2) (2023-09-04)


### Bug Fixes

* activate nextls when it detects a mix.exs file ([#165](https://github.com/elixir-tools/elixir-tools.nvim/issues/165)) ([061d7ad](https://github.com/elixir-tools/elixir-tools.nvim/commit/061d7ad919033d9d04b9a85e4aca75821f55e5b6))

## [0.9.1](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.9.0...v0.9.1) (2023-08-21)


### Bug Fixes

* **nextls:** correctly set autoupdate flag ([#162](https://github.com/elixir-tools/elixir-tools.nvim/issues/162)) ([2c1239f](https://github.com/elixir-tools/elixir-tools.nvim/commit/2c1239fef1bb76d08f6f6328bee04c10fc529476))

## [0.9.0](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.8.1...v0.9.0) (2023-08-21)


### Features

* :Elixir command with subcommands and completions ([#160](https://github.com/elixir-tools/elixir-tools.nvim/issues/160)) ([c4e1db5](https://github.com/elixir-tools/elixir-tools.nvim/commit/c4e1db5922787baa03ba2d7e7e3ce4e75a46f2e5))
* **nextls:** enable auto update ([#159](https://github.com/elixir-tools/elixir-tools.nvim/issues/159)) ([af1b5a8](https://github.com/elixir-tools/elixir-tools.nvim/commit/af1b5a84c01d281c261ff0f96b2982ee351373dc))

## [0.8.1](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.8.0...v0.8.1) (2023-08-10)


### Bug Fixes

* x86-64 -&gt; x86_64 ([#156](https://github.com/elixir-tools/elixir-tools.nvim/issues/156)) ([9479630](https://github.com/elixir-tools/elixir-tools.nvim/commit/9479630b37486a459e5a9fb0132072a16242a1fe))

## [0.8.0](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.7.2...v0.8.0) (2023-08-09)


### Features

* install prebuilt nextls binaries ([#153](https://github.com/elixir-tools/elixir-tools.nvim/issues/153)) ([af37b9f](https://github.com/elixir-tools/elixir-tools.nvim/commit/af37b9fb2749d2aa7cf1ecb3e3d3205538b0e244))

## [0.7.2](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.7.1...v0.7.2) (2023-08-01)


### Bug Fixes

* elixir-tools does not load when Github Rate Limit reached ([#151](https://github.com/elixir-tools/elixir-tools.nvim/issues/151)) ([de6d046](https://github.com/elixir-tools/elixir-tools.nvim/commit/de6d0461b1ea4928298bc7bdb0313c3d1ef146db))

## [0.7.1](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.7.0...v0.7.1) (2023-07-28)


### Bug Fixes

* workspace/didChangeWatchedFiles on nvim stable ([088bb2d](https://github.com/elixir-tools/elixir-tools.nvim/commit/088bb2dd940586647aadaec30506654e0e69d1c4)), closes [#148](https://github.com/elixir-tools/elixir-tools.nvim/issues/148)

## [0.7.0](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.6.6...v0.7.0) (2023-07-28)


### Features

* **nextls:** reuse client correctly for workspace folders ([22fe478](https://github.com/elixir-tools/elixir-tools.nvim/commit/22fe478395860765b7fc82a490b640eaf0e6f8cc))


### Bug Fixes

* connect to eelixir, heex, and surface filetypes ([f5da7e3](https://github.com/elixir-tools/elixir-tools.nvim/commit/f5da7e3b94d4f42dfba6f2db56cb62162c7c1351))

## [0.6.6](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.6.5...v0.6.6) (2023-07-20)


### Bug Fixes

* bump elixir-ls version ([#144](https://github.com/elixir-tools/elixir-tools.nvim/issues/144)) ([389fb56](https://github.com/elixir-tools/elixir-tools.nvim/commit/389fb56b46da025d0a650c128c7ebc296e7b58dd)), closes [#143](https://github.com/elixir-tools/elixir-tools.nvim/issues/143)

## [0.6.5](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.6.4...v0.6.5) (2023-06-26)


### Bug Fixes

* ensure elixir-tool.nvim cache dir exists ([5a3f6f3](https://github.com/elixir-tools/elixir-tools.nvim/commit/5a3f6f36e0263ffd2ac65767c12fd8f0f7c8010b))

## [0.6.4](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.6.3...v0.6.4) (2023-06-25)


### Bug Fixes

* bin/nextls ([545e9bb](https://github.com/elixir-tools/elixir-tools.nvim/commit/545e9bb152bc3c4bfad0d3aa1cbae058a4b357d8))

## [0.6.3](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.6.2...v0.6.3) (2023-06-25)


### Bug Fixes

* prep for next-ls release ([#132](https://github.com/elixir-tools/elixir-tools.nvim/issues/132)) ([1de4cc2](https://github.com/elixir-tools/elixir-tools.nvim/commit/1de4cc2b7140bc4788a293d0f64c014630e4f429))

## [0.6.2](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.6.1...v0.6.2) (2023-06-25)


### Bug Fixes

* cache latest release and fallback to it if call to GitHub fails ([#130](https://github.com/elixir-tools/elixir-tools.nvim/issues/130)) ([a33bb62](https://github.com/elixir-tools/elixir-tools.nvim/commit/a33bb62fef2defef3ea788f0ff989d840a8c652b))

## [0.6.1](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.6.0...v0.6.1) (2023-06-21)


### Bug Fixes

* **elixirls:** allow overriding handlers ([2fa5e75](https://github.com/elixir-tools/elixir-tools.nvim/commit/2fa5e75e7f5fac23a36567f43c205631b6b7910c))

## [0.6.0](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.5.1...v0.6.0) (2023-06-21)


### Features

* **elixir,treesitter:** highlight arg to Repo.query! as SQL ([4464531](https://github.com/elixir-tools/elixir-tools.nvim/commit/44645316f987d78d1afe6e6f8ac46839bb5a2bbc))
* **elixirls:** bump ElixirLS ([1014838](https://github.com/elixir-tools/elixir-tools.nvim/commit/101483829e25dc25d0e0e9fb3b090f7b4e07b964))

## [0.5.1](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.5.0...v0.5.1) (2023-06-15)


### Bug Fixes

* **nextls:** only start if explicitly enabled ([#126](https://github.com/elixir-tools/elixir-tools.nvim/issues/126)) ([40877be](https://github.com/elixir-tools/elixir-tools.nvim/commit/40877be58a22a338f24013612abe61cb2387eb8e))

## [0.5.0](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.4.0...v0.5.0) (2023-06-14)


### Features

* nextls ([#124](https://github.com/elixir-tools/elixir-tools.nvim/issues/124)) ([62b8184](https://github.com/elixir-tools/elixir-tools.nvim/commit/62b8184311b4451f008fb9328a4a50fac61941f9))

## [0.4.0](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.3.0...v0.4.0) (2023-06-11)


### Features

* Etask projection ([#119](https://github.com/elixir-tools/elixir-tools.nvim/issues/119)) ([3eb9c10](https://github.com/elixir-tools/elixir-tools.nvim/commit/3eb9c10dd53418b3f268a177f6876df1334a94e4)), closes [#92](https://github.com/elixir-tools/elixir-tools.nvim/issues/92)
* **projectionist:** Ejson and Elivecomponent ([#80](https://github.com/elixir-tools/elixir-tools.nvim/issues/80)) ([7af93b7](https://github.com/elixir-tools/elixir-tools.nvim/commit/7af93b721848c995436c5b7fbc32d5c299903d05))


### Bug Fixes

* **credo:** use -S in shebang line ([#122](https://github.com/elixir-tools/elixir-tools.nvim/issues/122)) ([6d8cbe9](https://github.com/elixir-tools/elixir-tools.nvim/commit/6d8cbe9a32dd8131eff326d3079948371248cf77))
* **projectionist:** don't append live to file and module name ([#121](https://github.com/elixir-tools/elixir-tools.nvim/issues/121)) ([e504b87](https://github.com/elixir-tools/elixir-tools.nvim/commit/e504b87859fb44d5d9d22ac12bc2a5418f74d6ac))

## [0.3.0](https://github.com/elixir-tools/elixir-tools.nvim/compare/v0.2.0...v0.3.0) (2023-06-08)


### Features

* configure credo-langauge-server version ([#104](https://github.com/elixir-tools/elixir-tools.nvim/issues/104)) ([4644c05](https://github.com/elixir-tools/elixir-tools.nvim/commit/4644c052dc36b370115c1cce8ac9dfee14c79ebf))
* connect to credo via port ([09eaf34](https://github.com/elixir-tools/elixir-tools.nvim/commit/09eaf3457365227deea15ee8ceb08d69f9907292))
* **credo:** auto install latest version ([#114](https://github.com/elixir-tools/elixir-tools.nvim/issues/114)) ([23c3e7b](https://github.com/elixir-tools/elixir-tools.nvim/commit/23c3e7b5d08f0c5f678b86e608381d5d1f47a395))
* healthcheck ([#89](https://github.com/elixir-tools/elixir-tools.nvim/issues/89)) ([c9ec34a](https://github.com/elixir-tools/elixir-tools.nvim/commit/c9ec34a8d8050ff122cc34b709be664c2ab84b06))
* projections for phoenix 1.7 ([#50](https://github.com/elixir-tools/elixir-tools.nvim/issues/50)) ([53946c8](https://github.com/elixir-tools/elixir-tools.nvim/commit/53946c8d1d9f7ab8f5dff8834960fb547db2bf9b))
* **treesitter:** injections ([#75](https://github.com/elixir-tools/elixir-tools.nvim/issues/75)) ([ca34b3e](https://github.com/elixir-tools/elixir-tools.nvim/commit/ca34b3ef6bce06f7f22b0d1b8a740029779f5d8a)), closes [#9](https://github.com/elixir-tools/elixir-tools.nvim/issues/9)


### Bug Fixes

* correctly fetch path to credo-language-server ([#65](https://github.com/elixir-tools/elixir-tools.nvim/issues/65)) ([8f40d76](https://github.com/elixir-tools/elixir-tools.nvim/commit/8f40d76710d1d43c114c983afedf7fac902a3445)), closes [#64](https://github.com/elixir-tools/elixir-tools.nvim/issues/64)
* credo-language-server is installed quietly ([#115](https://github.com/elixir-tools/elixir-tools.nvim/issues/115)) ([6f59909](https://github.com/elixir-tools/elixir-tools.nvim/commit/6f59909618e96f78293084be5ed427da48c8ca70))
* **credo:** correctly handle umbrella apps and monorepos ([#77](https://github.com/elixir-tools/elixir-tools.nvim/issues/77)) ([86bda38](https://github.com/elixir-tools/elixir-tools.nvim/commit/86bda3872792fe3bfe07b936eeb3f26d5a616b50)), closes [#76](https://github.com/elixir-tools/elixir-tools.nvim/issues/76)
* improve BufEnter performance ([#87](https://github.com/elixir-tools/elixir-tools.nvim/issues/87)) ([08b7843](https://github.com/elixir-tools/elixir-tools.nvim/commit/08b7843979266cbf928815fdc8859dc1136f6ef3))
* only start credo if it finds a mix.exs with credo in it ([#68](https://github.com/elixir-tools/elixir-tools.nvim/issues/68)) ([43c2288](https://github.com/elixir-tools/elixir-tools.nvim/commit/43c2288bfebf76e85ca8b607ebf53262ed0f3d28))
* remove leading 'v' in latest version ([#116](https://github.com/elixir-tools/elixir-tools.nvim/issues/116)) ([945d161](https://github.com/elixir-tools/elixir-tools.nvim/commit/945d161cb7d1c58127b7af7c6951e0c6d0c69314))
* umbrella app detection ([#88](https://github.com/elixir-tools/elixir-tools.nvim/issues/88)) ([a17c863](https://github.com/elixir-tools/elixir-tools.nvim/commit/a17c86398daa4777f276c1f5855155459d7853b6))

## v0.2.0

- [credo-language-server](https://github.com/elixir-tools/credo-language-server) support
- Set the commentstring for the surface filetype.
- can disable ElixirLS and credo-language-server with the `enable` option.

## v0.1.0

Initial Release

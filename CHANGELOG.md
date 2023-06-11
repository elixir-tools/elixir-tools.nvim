# CHANGELOG

## Unreleased

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

# Changelog

## [0.3.2](https://github.com/elct9620/ai-coding-skills/compare/v0.3.1...v0.3.2) (2026-03-16)


### Bug Fixes

* **skills:** enforce outside-in implementation order instead of implicit inside-out ([f172bd1](https://github.com/elct9620/ai-coding-skills/commit/f172bd1ab28fc9fdbf2074dda7570dd7df3657c8))

## [0.3.1](https://github.com/elct9620/ai-coding-skills/compare/v0.3.0...v0.3.1) (2026-03-14)


### Bug Fixes

* **skills:** strengthen TDD phase confirmation and relax AAA for compact tests ([24ced62](https://github.com/elct9620/ai-coding-skills/commit/24ced62c59fe74328b0ef39ea2bf63c7e5ab7cfb))

## [0.3.0](https://github.com/elct9620/ai-coding-skills/compare/v0.2.0...v0.3.0) (2026-03-13)


### Features

* **commands:** add architecture validation gate to refactor command ([9a239f6](https://github.com/elct9620/ai-coding-skills/commit/9a239f676897bc648425a7a67941f0664776635d))
* **commands:** add review command for post-implementation quality checks ([dca6b7c](https://github.com/elct9620/ai-coding-skills/commit/dca6b7cb254deeb35a4d2e83e2820238bbc64c9a))
* **commands:** add TaskCreate step after plan approval for progress tracking ([8b81054](https://github.com/elct9620/ai-coding-skills/commit/8b810543091692048bbf96c16dcded0a1db4c621))
* **commands:** add WebSearch support for external research in all commands ([1a33f7b](https://github.com/elct9620/ai-coding-skills/commit/1a33f7be63652ea683d2fb692cc3693f5f311677))
* **commands:** add workflow chaining guidance between commands ([ad98d3e](https://github.com/elct9620/ai-coding-skills/commit/ad98d3e2ea779c6efd12a02305dbc9392662ebb8))
* **skills:** add boundary testing guidance to prevent testing third-party code ([e1b9692](https://github.com/elct9620/ai-coding-skills/commit/e1b96925fe46634d8e3672163407f27fc59cbc87))
* **skills:** add dead code detection guidance to testing skill ([678be10](https://github.com/elct9620/ai-coding-skills/commit/678be106562fb98f0077cf4bffe1daff60c330c7))
* **skills:** add security skill for vulnerability prevention ([610b34e](https://github.com/elct9620/ai-coding-skills/commit/610b34e1fd80cc52e69f936df83ff183252e5c8f))
* **skills:** address eval-identified gaps in 5 skills ([3b7aff6](https://github.com/elct9620/ai-coding-skills/commit/3b7aff6d0628e466bed2d12b296be383c6fae1bb))
* **skills:** improve triggering accuracy, cross-references, and domain-modeling depth ([2e853ed](https://github.com/elct9620/ai-coding-skills/commit/2e853ed7019d2ae03dfccc802d2de04e19704bc2))


### Bug Fixes

* **commands:** make investigate mandatory and add project boundary constraints ([3c7d6f2](https://github.com/elct9620/ai-coding-skills/commit/3c7d6f2a04d5fc7df8470fe19cedd79e77df13bf))
* **skills:** align testing skill with integration-first philosophy ([83b02b2](https://github.com/elct9620/ai-coding-skills/commit/83b02b24c0705bd83bd16faee4943c25ea41e4fd))

## [0.2.0](https://github.com/elct9620/ai-coding-skills/compare/v0.1.0...v0.2.0) (2026-02-11)


### Features

* **commands:** add design-patterns skill and fix skill naming format ([48ef0e8](https://github.com/elct9620/ai-coding-skills/commit/48ef0e8f9e2e324b4dab95b88d343b62625162ea))
* **commands:** add execution phase and quality report to write command ([9169ea1](https://github.com/elct9620/ai-coding-skills/commit/9169ea1d0b886a9b33f5dd93477d3f558a79f8bc))
* **commands:** add fix command for bug diagnosis and repair ([a8eb071](https://github.com/elct9620/ai-coding-skills/commit/a8eb0718d9120697efa158eb7b0f6a9db737d9c4))
* **commands:** add refactor command for legacy code cleanup ([e12f863](https://github.com/elct9620/ai-coding-skills/commit/e12f863e372d67995229ba6b16e92f1f9964f6d2))
* **commands:** add skill discovery step to active-skills function ([1883b6b](https://github.com/elct9620/ai-coding-skills/commit/1883b6bcc38f2e211e1e040dc4d7afe0c8bb510f))
* **commands:** add write command for feature implementation ([f76a0f0](https://github.com/elct9620/ai-coding-skills/commit/f76a0f00ad5d492ec7f6cd1fe6e67565b841a6f7))
* **commands:** allow model invocation for fix, write, and refactor ([7cdc8cd](https://github.com/elct9620/ai-coding-skills/commit/7cdc8cd01408f5d036d9cf47da57a59debcd7a7f))
* **commands:** improve write command with plan creation and skip-tests option ([beff762](https://github.com/elct9620/ai-coding-skills/commit/beff762ef5479372ec35be67b01a642c0773b2dd))
* **skills:** add coding skills with decision tables ([24bbe49](https://github.com/elct9620/ai-coding-skills/commit/24bbe498844a809e1deb7990d8c79b0fffa1cf17))
* **skills:** add integration-first testing philosophy ([5c49af9](https://github.com/elct9620/ai-coding-skills/commit/5c49af905ae6dab58c6db40cb3001b864517c02b))
* **skills:** add schema skill for database and API contract design ([35dae07](https://github.com/elct9620/ai-coding-skills/commit/35dae07c69544bbd355862f1e269fd6dd38a3026))


### Bug Fixes

* **commands:** add git history check to refactor analyze-smells ([6a6fa4f](https://github.com/elct9620/ai-coding-skills/commit/6a6fa4f13fd4f8ccd1953dfbc57453d4abf737ce))
* **commands:** defer plan mode entry until after exploration phase ([d2942c8](https://github.com/elct9620/ai-coding-skills/commit/d2942c808fa3d955e740d1cf1c61a358be930d16))
* **commands:** enforce skill activation in active-skills function ([07e2616](https://github.com/elct9620/ai-coding-skills/commit/07e261659cfefe49d160fd346014fcd7c1074581))
* **commands:** remove auto-commit and let user decide ([e4c0689](https://github.com/elct9620/ai-coding-skills/commit/e4c0689ffc6499b05c0420fa904a21a9be102925))
* **skills:** correct Clean Architecture layers from DDD to original 4-layer model ([a31d0df](https://github.com/elct9620/ai-coding-skills/commit/a31d0dfa606fa1c91d5a4652cf0e687d876be0d7))

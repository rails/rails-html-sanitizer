Contributing to ActionView Html Sanitizers
=====================

[![Build Status](https://github.com/rails/actionview-html-sanitizer/actions/workflows/ci.yml/badge.svg)](https://github.com/rails/actionview-html-sanitizer/actions/workflows/ci.yml)

ActionView Html Sanitizers is work of [many contributors](https://github.com/rails/actionview-html-sanitizer/graphs/contributors). You're encouraged to submit [pull requests](https://github.com/rails/actionview-html-sanitizer/pulls), [propose features and discuss issues](https://github.com/rails/actionview-html-sanitizer/issues).

### How to submit a pull request

#### Fork the Project

Fork the [project on Github](https://github.com/rails/actionview-html-sanitizer) and check out your copy.

```
git clone https://github.com/contributor/actionview-html-sanitizer.git
cd actionview-html-sanitizer
git remote add upstream https://github.com/rails/actionview-html-sanitizer.git
```

#### Create a Topic Branch

Make sure your fork is up-to-date and create a topic branch for your feature or bug fix.

```
git checkout main
git pull upstream main
git checkout -b my-feature-branch
```

#### Bundle Install and Test

Ensure that you can build the project and run tests.

```
bundle install
bundle exec rake test
```

#### Write Tests

Try to write a test that reproduces the problem you're trying to fix or describes a feature that you want to build. Add to [test](test).

We definitely appreciate pull requests that highlight or reproduce a problem, even without a fix.

#### Write Code

Implement your feature or bug fix.

Make sure that `bundle exec rake test` completes without errors.

#### Write Documentation

Document any external behavior in the [README](README.md).

#### Commit Changes

Make sure git knows your name and email address:

```
git config --global user.name "Your Name"
git config --global user.email "contributor@example.com"
```

Writing good commit logs is important. A commit log should describe what changed and why.

```
git add ...
git commit
```

#### Push

```
git push origin my-feature-branch
```

#### Make a Pull Request

Go to https://github.com/contributor/actionview-html-sanitizer and select your feature branch. Click the 'Pull Request' button and fill out the form. Pull requests are usually reviewed within a few days.

#### Rebase

If you've been working on a change for a while, rebase with upstream/main.

```
git fetch upstream
git rebase upstream/main
git push origin my-feature-branch -f
```

#### Check on Your Pull Request

Go back to your pull request after a few minutes and see whether it passed muster with CI. Everything should look green, otherwise fix issues and amend your commit as described above.

#### Be Patient

It's likely that your change will not be merged and that the nitpicky maintainers will ask you to do more, or fix seemingly benign problems. Hang on there!

#### Thank You

Please do know that we really appreciate and value your time and work. We love you, really.

### How to cut a release

A quick checklist:

- [ ] make sure CI is green! https://github.com/rails/actionview-html-sanitizer/actions/workflows/ci.yml
- [ ] update `CHANGELOG.md` and `lib/action_view/html/sanitizer/version.rb`
- [ ] run `bundle exec rake build`
- [ ] create a git tag
- [ ] `git push && git push --tags`
- [ ] `gem push pkg/*.gem`
- [ ] create a release at https://github.com/rails/actionview-html-sanitizer/releases
- if security-related,
  - [ ] publish the CVE
  - [ ] post to https://discuss.rubyonrails.org/c/security-announcements
  - [ ] submit a PR to https://github.com/rubysec/ruby-advisory-db

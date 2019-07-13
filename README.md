# Puppeteer Headful

[Github Action](https://github.com/features/actions) for [Puppeteer](https://github.com/GoogleChrome/puppeteer) that can be ran "headful" or not headless.

> Versioning of this container is based on the version of NodeJS in the container

## Purpose

This container is available to Github Action because there is some situations ( mostly testing [Chrome Extensions](https://pptr.dev/#?product=Puppeteer&version=v1.18.1&show=api-working-with-chrome-extensions) ) where you can not run Puppeteer in headless mode.

## Usage

This installs Puppeteer ontop of a [NodeJS](https://nodejs.org) container so you have access to run [npm](https://www.npmjs.com) scripts using args. For this hook we hyjack the entrypoint of the [Dockerfile](https://docs.docker.com/engine/reference/builder/) so we can startup [Xvfb](https://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml) before your testing starts.

```terraform

action "Install Dependencies" {
  uses = "actions/npm@master"
  args = "install"
  env = {
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "true"
  }
}

action "Test Code" {
  uses = "jcblw/puppeteer-headful@master"
  needs = "Install Dependencies"
  args = ["test"], # npm test
  env = {
    CI = "true"
  }
}
```

> Note: You will need to let Puppeteer know not to download Chromium. By setting the env of your install task to PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = 'true' so it does not install conflicting versions of Chromium.

Then you will need to change the way you launch Puppeteer. We export out a nifty ENV variable `PUPPETEER_EXEC_PATH` that you set at your `executablePath`. This should be undefined locally so it should function perfectly fine locally and on the action.

```javascript
browser = await puppeteer.launch({
  executablePath: process.env.PUPPETEER_EXEC_PATH, // set by docker container
  headless: false,
  ...
});
```

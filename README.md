# Fringr

This is the web-based implementation of Fringr, an automatic algorithm used to schedule Westmont College's Fringe Festival. Fringr can be found [here](https://fringr.herokuapp.com/)

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```

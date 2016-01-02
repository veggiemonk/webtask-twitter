# Webtask-Twitter

This is more a proof of concept rather then a full featured twitter cli. 
This project can be the based for a twitter related project and demonstrate the use of a really nice (and free) service called [webtask.io](https://webtask.io/).

This project was heavily inspired by this [repo](https://github.com/bananaoomarang/webtask-ifttt-tutorial). 
I recommend you check it out if you want to learn more tricks about webtasks.
You can upload JavaScript code (such as `webtask.js` in this repo) to webtask.io and it will run as a node server. 
Run JavaScript with an HTTP call. No provisioning. No deployment.
The best thing is that it supports ES6!

And you can receive your tweet (or whoever will give access to that webtask) on your cli:
<h1 align="center">
	<br>
	<img width="800" src="https://rawgit.com/veggiemonk/webtask-twitter/master/screenshot.png" alt="screenshot">
	<br>
	<br>
	<br>
</h1>
# How to use this ?

## Dependencies

### I just want the bare cli

`node` is required by the webtask cli ( `wt-cli` ).
`curl` or `wget` is needed to retrieve data from the webtask.

### I want the beautiful colors

There is a script called `start.sh` to get you started. Feel free to use whatever works for you.
It needs:
  - `curl`: Transferring data with URL syntax. It should be available in your distro `http://curl.haxx.se/download.html`
  - `egrep`: Colorized pattern. It should be available in your distro `https://www.gnu.org/software/grep/`
  - `jq`: JSON processor written in C and has no runtime dependencies. `https://stedolan.github.io/jq/download/`
  - `emojify`: Just because emoji. `https://github.com/mrowa44/emojify`

## How to install the webtask ?

### 1. Install the webtask-cli

```sh
 npm install -g wt-cli
```

### 2. Initialized you account

```sh
 wt init youremail@ddress.com
```

### 3. Set your token and secret as environment variable

To have access to your tweet your need to authorize your application at https://apps.twitter.com/

Export your secrets:

```sh
 export WT_TOKEN='...'
 export WT_SECRET='...'
 export WT_CONSUMER_KEY='...'
 export WT_CONSUMER_SECRET='...'
```

> If your store those information in a file, please don't commit it to your repository! Use .gitignore!!
  It is not recommended to store secrets in file! 
  
However you can put a space before typing the `export` so that your terminal does not save command to your history. 
Which is the same as storing your secret in a file. 

Ensure that this feature is activated in your terminal by typing  `setopt hist_ignore_space`.   

Better safe than sorry.



### 4. Install the webtask with the secrets

The values exported in the previous step will be passed to a variable `ctx.data` in the webtask code.
The name of the parameter (ex: `token`) can be retrieved as `ctx.data.token`

```sh
  wt create --secret token=$WT_TOKEN --secret secret=$WT_SECRET --secret consumerKey=$WT_CONSUMER_KEY --secret consumerSecret=$WT_CONSUMER_SECRET webtask.js
```

If the command is **successful** you should see a url like :
```
https://webtask.it.auth0.com/api/run/(webtask_ID)/webtask?webtask_no_cache=1
```

# Show me my tweet on the cli!

Once installed, just `curl` the url you received from `wt create`:
```
 curl https://webtask.it.auth0.com/api/run/(webtask_ID)/webtask?webtask_no_cache=1
```

# Watch tweet in colors

Make sure you have the dependencies ready. If not, the script will try to download them for you. They are pretty much standalone and/or available in your distro.

```sh
./start.sh https://webtask.it.auth0.com/api/run/(webtask_ID)/webtask?webtask_no_cache=1
```

# Use cases

* Shared account: you can share your stream by sharing the url of the webtask.
* Proxy bypassing: 'nuff said.
* Filter tweets: you can exclude tweets that you don't want (ads/promoted/troll) or merge many streams/accounts.
* Colors: It is pretty in the terminal, you can create your own filters to make whatever is relevant to you stand out.

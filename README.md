# webtask-twitter

# INSTALL

## Dependencies

### I just want the bare cli

`node` is requiered by the webtask cli ( `wt-cli` ).
`curl` or `wget` is needed to retrieve data from the webtask.

### I want the beautiful colors

There is a script called `start.sh` to get you started.
It needs:
  - `curl`: Transferring data with URL syntax. It should be available in your distro `http://curl.haxx.se/download.html`
  - `egrep`: Colorized pattern. It should be available in your distro `https://www.gnu.org/software/grep/`
  - `jq`: JSON processor written in C and has no runtime dependencies. `https://stedolan.github.io/jq/download/`
  - `emojify`: Just because emoji. `https://github.com/mrowa44/emojify`

## How to install the webtask

### Install the webtask-cli

```sh
 npm install -g wt-cli
```

### Initialized you account

```sh
 wt init youremail@ddress.com
```

### Set your token and secret as environment variable

Read the next to understand why

```sh
 export WT_TOKEN='...'
 export WT_SECRET='...'
 export WT_CONSUMER_KEY='...'
 export WT_CONSUMER_SECRET='...'
```

> If your store those information as a file, please don't commit it to your repository! Use .gitignore!!
  It is not recommended to store secrets as file! 
  
However you can put a space before typing the `export` so that your terminal does not save this to your history. 
Which is the same as storing your secret as a file. 
Ensure that this feature is activated in your terminal by typing  `setopt hist_ignore_space`.   

Better safe than sorry.



### Install the webtask with the secrets

The values exported in the previous step will be passed to a variable `ctx.data` in the webtask code.
The name of the parameter (ex: `token`) can be retrieved as `ctx.data.token`

```sh
  wt create --secret token=$WT_TOKEN --secret secret=$WT_SECRET --secret consumerKey=$WT_CONSUMER_KEY --secret consumerSecret=$WT_CONSUMER_SECRET webtask.js
```

If the command is **successful** you should see a url like :
```
https://webtask.it.auth0.com/api/run/(webtask_ID)/webtask?webtask_no_cache=1
```

# Show me my tweet on the cli!!

Once installed, just `curl` the url you received from `wt create`:
```
 curl https://webtask.it.auth0.com/api/run/(webtask_ID)/webtask?webtask_no_cache=1
```

# Use cases

* Shared account: you can share your stream by sharing the url of the webtask.
* Proxy bypassing: 'nuff said.
* Filter tweets: you can exclude tweets that you don't want (ads/promoted/troll) or merge many streams/accounts.
* Colors: It is pretty in the terminal, you can create your own filters to make whatever is relevant to you stand out.

_There is an issue with the way Katacoda configures the bash shell. Please execute the following command to launch a new shell that is properly configured._

```
bash
```{{execute}}

Now we are ready.


Using the rules described in Step 7, we were able to prevent access to a specific URL. We will now be using the opposite approach: We want to make sure that only one specific URL can be accessed. In addition, we will only be accepting previously known _POST parameters_ in a specified format. This is a very tight security technique which is also called positive security: It is no longer us trying to find known attacks in user submitted content, it is now the user who has to proof that his request meets all our criteria.

Our example is a whitelist for a login with display of the form, submission of the credentials and the logout. We do not have the said login in place, but this does not stop us from defining the ruleset to protect this hypothetical service in our lab. And if you have a login or any other simple application you want to protect, you can take the code as a template and adopt as suitable.

So here are the rules (I will explain them in detail afterwards):

```
SecMarker BEGIN_WHITELIST_login

# Make sure there are no URI evasion attempts
SecRule REQUEST_URI "!@streq %{REQUEST_URI_RAW}" \
    "id:11000,phase:1,deny,t:normalizePathWin,log,\
    msg:'URI evasion attempt'"

# START whitelisting block for URI /login
SecRule REQUEST_URI "!@beginsWith /login" \
    "id:11001,phase:1,pass,t:lowercase,nolog,skipAfter:END_WHITELIST_login"
SecRule REQUEST_URI "!@beginsWith /login" \
    "id:11002,phase:2,pass,t:lowercase,nolog,skipAfter:END_WHITELIST_login"

# Validate HTTP method
SecRule REQUEST_METHOD "!@pm GET HEAD POST OPTIONS" \
    "id:11100,phase:1,deny,status:405,log,tag:'Login Whitelist',\
    msg:'Method %{MATCHED_VAR} not allowed'"

# Validate URIs
SecRule REQUEST_FILENAME "@beginsWith /login/static/css" \
    "id:11200,phase:1,pass,nolog,tag:'Login Whitelist',\
    skipAfter:END_WHITELIST_URIBLOCK_login"
SecRule REQUEST_FILENAME "@beginsWith /login/static/img" \
    "id:11201,phase:1,pass,nolog,tag:'Login Whitelist',\
    skipAfter:END_WHITELIST_URIBLOCK_login"
SecRule REQUEST_FILENAME "@beginsWith /login/static/js" \
    "id:11202,phase:1,pass,nolog,tag:'Login Whitelist',\
    skipAfter:END_WHITELIST_URIBLOCK_login"
SecRule REQUEST_FILENAME \
    "@rx ^/login/(displayLogin|login|logout).do$" \
    "id:11250,phase:1,pass,nolog,tag:'Login Whitelist',\
    skipAfter:END_WHITELIST_URIBLOCK_login"

# If we land here, we are facing an unknown URI,
# which is why we will respond using the 404 status code
SecAction "id:11299,phase:1,deny,status:404,log,tag:'Login Whitelist',\
    msg:'Unknown URI %{REQUEST_URI}'"

SecMarker END_WHITELIST_URIBLOCK_login

# Validate parameter names
SecRule ARGS_NAMES "!@rx ^(username|password|sectoken)$" \
    "id:11300,phase:2,deny,log,tag:'Login Whitelist',\
    msg:'Unknown parameter: %{MATCHED_VAR_NAME}'"

# Validate each parameter's uniqueness
SecRule &ARGS:username  "@gt 1" \
    "id:11400,phase:2,deny,log,tag:'Login Whitelist',\
    msg:'%{MATCHED_VAR_NAME} occurring more than once'"
SecRule &ARGS:password  "@gt 1" \
    "id:11401,phase:2,deny,log,tag:'Login Whitelist',\
    msg:'%{MATCHED_VAR_NAME} occurring more than once'"
SecRule &ARGS:sectoken  "@gt 1" \
    "id:11402,phase:2,deny,log,tag:'Login Whitelist',\
    msg:'%{MATCHED_VAR_NAME} occurring more than once'"

# Check individual parameters
SecRule ARGS:username "!@rx ^[a-zA-Z0-9.@_-]{1,64}$" \
    "id:11500,phase:2,deny,log,tag:'Login Whitelist',\
    msg:'Invalid parameter format: %{MATCHED_VAR_NAME} (%{MATCHED_VAR})'"
SecRule ARGS:sectoken "!@rx ^[a-zA-Z0-9]{32}$" \
    "id:11501,phase:2,deny,log,tag:'Login Whitelist',\
    msg:'Invalid parameter format: %{MATCHED_VAR_NAME} (%{MATCHED_VAR})'"
SecRule ARGS:password "@gt 64" \
    "id:11502,phase:2,deny,log,t:length,tag:'Login Whitelist',\
    msg:'Invalid parameter format: %{MATCHED_VAR_NAME} too long (%{MATCHED_VAR} bytes)'"
SecRule ARGS:password "@validateByteRange 33-244" \
    "id:11503,phase:2,deny,log,tag:'Login Whitelist',\
    msg:'Invalid parameter format: %{MATCHED_VAR_NAME} (%{MATCHED_VAR})'"

SecMarker END_WHITELIST_login

```

Since this is a multi-line set of rules, we delimit the group of rules using two markers: *BEGIN_WHITELIST_login* and *END_WHITELIST_login*. We only need the first marker for readability, but the second one is a jump label. The first rule (ID 11000) enforces our policy to deny requests containing two dots in succession in the URI. Two dots in succession might serve as a way to evade our subsequent path criteria. E.g., constructing an URI which looks like accessing some other folder, but then uses `..` to escape from that folder and access `/login` nevertheless. This rule makes sure none of these games can be played with our server.

In the two following rules (ID 11001 and 11002) we check whether our set of rules is affected at all. If the path written in lowercase and normalized does not begin with _/login_, we skip to the end marker - with no entry in the log file. It would be possible to place the entire block of rules within an Apache *Location* block, however, I prefer the rule style presented here. The whitelist we are constructing is a partial whitelist as it does not cover the whole server. Instead, it focuses on the login with the idea, that the login page will be accessed by anonymous users. Once they have performed the login, they have at least proved their credentials and a certain trust has been established. The login is thus a likely target for anonymous attackers and we want to secure it really well. It is also likely that any application on the server is more complex than the login and writing a positive ruleset for an advanced application would be too complicated for this tutorial. But the limited scope of the login makes it perfectly achievable and it adds a lot of security. The example serves as a template to use for other partial whitelists.

Having established the fact that we are dealing with a login request, we can now write down our rules checking these request. An HTTP request has several characteristics that are of concern to us: The method, the path, the query string parameter as well as any post parameters (this concerns the submission of a login form). We will leave out the request headers including cookies in this example, but they could also become a vulnerability depending on the application and should also be queried then.

First, we look at the HTTP method in rule ID 11100. Displaying the login form is going to be a _GET_ request; submitting the credentials will be a _POST_ request. Some clients like to issue _HEAD_ and _OPTIONS_ requests as well and not much harm is done by permitting these requests. Everything else, _PUT_ and _DELETE_ and all the webdav methods, are being blocked by this rule. We check the four whitelisted methods with a parallel matching operator (`@pm`). This is faster then a regular expression and it is also more readable. Because we want to follow best practices, we do not simply return the default status code 403 (Forbidden), but we return 405 which indicates to the client, that the method is not allowed.

In the rule block starting at rule ID 11200, we examine the URL in detail. We establish three folders, where we allow access to static files: `/login/static/css/`, `/login/static/img/` and `/login/static/js/`. We do not want to micromanage the individual files retrieved from these folders, so we simply allow access to these folders. The rule ID 11250 is different. It defines the targets of the dynamic requests of the users. We construct a regular expression which allows exactly three URIs: `/login/displayLogin.do`, `/login/login.do` and `/login/logout.do`. Anything outside this list is going to be forbidden.

But how is all this checked? After all, it's a complicated set of paths spread over several rules! The rules 11200, 11201, 11202 and 11250 check for the URI. If we have a match, we do not block, but we jump to the label `END_WHITELIST_URIBLOCK_login`. When we arrive at this label, we know that the URI is one of the predefined set: the request adheres to our rules. But if we pass 11250 and still no hit with the URI, then we know that the client looks like an offender and we can block it accordingly. This is performed in the fallback rule with ID 11299. Notice, how this is not a conditional _SecRule_, but a _SecAction_ which is the same thing, but without an operator and without a parameter. The actions are executed immediately with the goal to block the request. Here is a twist: if we block in this rule, we do not tell the client his request was forbidden (HTTP status 403, which would be the default for a _deny_). We return a HTTP status 404 instead and leave the client in the dark about the existence of our ruleset.

Now it is time to look at parameters. There are query string parameters and POST parameters. We could look at them separately, but it is more convenient to treat them as one group. The POST parameters will only be available in the 2nd phase, so all the rules from here to the end of our whitelist will work in phase 2.

There are three things to check for any parameter: the name (do we know the parameter?), the uniqueness (is it submitted more than once? I will explain this shortly) and the format (does the parameter follow our predefined pattern?).
We perform the checks one after the other starting with the name in rule ID 11300. Here we check for a predefined list of parameter names. We expect three individual parameters: _username_, _password_ and a _sectoken_. Anything outside this list is forbidden. Unlike the check for the HTTP method, we use a regular expression here even if we could make this rule more readable by using the parallel matching operator `@pm`. The reason being, parallel matching treats uppercase and lowercase characters the same. So you could submit a parameter named _userName_, it would pass the name check and the subsequent rules might overlook it based on the odd capital _N_. So let's stick to the regular expression here.

So what's the matter with this uniqueness check. Let me explain it as follows: Suppose an attacker submits a parameter twice in the same request. What will happen in the application? Will the application use the first occurrence? The second occurrence? Both? Or will it concatenate? Honestly, we do not know. That's why we need to stop this: We count all the parameter and if any one of them is appearing more than once, we stop the request. There is one rule for each parameter starting with rule 11400. If you examine the rules carefully, you see the _&_ character in front of the _ARGS_. This means that we do not look at the parameter itself, but we want to count its occurrence. The operator `@gt` will then simply match any sum bigger than 1.

We are slowly coming to an end now. But before we do, we need to look at the individual parameters: Do they match a predefined pattern? In the case of the username (rule ID 11500) and the sectoken (rule ID 11501), the case is quite clear: We know how a username is supposed to look like on our site and for the machine generated sectoken it is even easier. So we use regular expressions to check this format.

The case with the password is less obvious. Apparently, we want users to use a lot of special characters. Ideally special characters outside the standard ascii set. But how do we check their format? We are hitting a limit here. Allowing the full character range, we also allow exploits and there is not much we can do about it with the whitelisting approach. But let's not give up so fast and enforce at least some limit. First we look at the length of the password parameter. Longer parameter means more room to construct an attack. We can limit this by leveraging the _length_ transformation. The operator in the rule will thus not look at the parameter itself, but at its length. The `@ge` operator is a good fit. If the password is longer than 64 bytes, then we deny access. In the next and final rule (ID 11503), we use another operator to validate the byterange. As we are expecting special characters, we need to make sure the visible UTF-8 range is allowed. This enforces some miminal standard, but it also means that the application will need to remain vigilant on the password parameter as it can not be locked down the same way as the username and the sectoken.

This concludes our partial whitelisting example.

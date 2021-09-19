Our minimal server has thus been described. It would be possible to define a server that is even more bare bones. It would however not be as comfortable to work with as ours and it wouldn’t be any more secure. A certain amount of basic security is however advisable. This is because in the lab we are building a service which should then with specific adjustments be able to be put into a production environment. Wanting to secure a service from top to bottom right before entering a production environment is illusory.

From now on, we will need two terminals open. One for the server (running in the foreground) and one terminal to run commands from. On top of the Katacoda Terminal window, there is a large plus-sign that let's you add another terminal tab. Choose "Open New Terminal" when the menu pops up.

The new terminal tab opens, and you can now type there and launch the server in the foreground (not as a daemon!) just the way we did in the Scenario / Tutorial 1:

```
cd /apache
```{{execute}}

```
sudo ./bin/httpd -X
```{{execute}}

 

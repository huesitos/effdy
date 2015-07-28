# Effdy

Effdy is a study app that uses the Ebbinghaus forgetting curve to schedule the reviews of the study material. As of now the user can create flashcards inside topics. Also, users can create subjects that contain topics. In addition, users can send a copy of a topic/subject or collaborate any of them with another user.

## Technical information

Ruby version: 2.2.0

Effdy runs with MongoDB and Mongoid. To install it, follow the corresponding guide in the [manual](http://docs.mongodb.org/manual/installation/) based on your OS. A mongod process should be running before starting the rails server. In the terminal, run:

	mongod

or

	service mongod start

## Twitter, Google, and Facebook OAuth keys

To facilitate using OAuth with the afore mentioned apps, three sandbox apps were created. Export their keys to your environment. Use 

Twitter app keys:

	TWITTER_KEY="sO76BROG8tDqxcDZTFSRQPnqk"
	TWITTER_SECRET="hakGScjADf3cwJJCHpiNVjmsXKpoh0HO47GaFo8um1WkvdKntG"

Facebook app keys:

	FACEBOOK_APP_ID="138516613149284"
	FACEBOOK_SECRET="2659fbd549062ebb82f08b2647fcc36c"

Google app keys:

	GOOGLE_CLIENT_ID="492002763865-6ijkv88vkemnq4br0bm9b38ks3v6mmt5.apps.googleusercontent.com"
	GOOGLE_CLIENT_SECRET="dxoERDk24mTCpMOBolcERf_H"

## Demo app

There master branch is currently running on a Heroku server. If you want to have a feel of what it is about, check it out [here](http://afternoon-journey-8075.herokuapp.com/login).

## Wiki

We have some [wiki](https://github.com/huesitos/effdy/wiki) pages that give a brief description of the project and what has been accomplished so far, and what we want to accomplish in the future.

## TODO

* Implement test suite
* Any other wild [issue](https://github.com/huesitos/aplus/issues) that appears.

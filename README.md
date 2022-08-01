# Many Hands *(work in progress)*

This is an iOS app that aims to tell the story of second-hand items through the owners that used them.

Here is the concept idea:

- You sell something that you own.
- You add it to Many Hands, and add your own story with that product.
- You get a "Many Hands code" that lets people access the product page on Many Hands.
- You make sure to write down the Many Hands code somewhere for the next owner to see it (on the label for example).
- The person buying the product can enter the code on Many Hands and access its product page, see your story, and add their own story with the product.
- That person sells the product to someone else, and makes sure that the Many Hands code is still visible.
- That new person can check the product history on Many Hands by entering the same code, and share their own story.
- Etc.

## Technologies used

This project uses the following technologies:

- Swift with UIKit
- MVVM design pattern
- Unit testing / Dependency injection
- RxSwift
- SnapKit
- Firebase Authentication
- Firebase Firestore Database



## Installation


- Run `pod install` from the root directory.
- Open **ManyHands.xcworkspace**.
- Set your own Bundle Identifier from the project target General settings.
- Set up a project on Firebase that uses Authentication and Firestore.
- Add the `GoogleService-Info.plist` file you get from Firebase into the project.


## Authentication setup

You should setup your Firebase project to support Authentication by email and password.

## Database structure

This project uses the following data collections on Firebase Firestore:

- users:
	- name (String)
	- email (String)
- products:
	- humanReadableId (String)
	- name (String)
	- description (String)
	- ownerUserId (String)
	- originalOwnerUserId (String)
	- entryDate (Timestamp)
	- historyEntries (Sub-collection)
- productUserAssociations:
	- productId (String)
	- userId (String)
	- owningFromDate (Timestamp)
	- owningUntilDate (Timestamp)

Each `product` can have a `historyEntries` sub-collection, with the following format:

- historyEntries:
	- userId (String)
	- entryText (String)
	- entryDate (Timestamp)

## Current state

- Basic login and registration feature works.
- Fetching a product and its history entries works.
- Adding a new entry if user is owner of the product works.
- Deleting any entry that the user inserted works.

![Login Page](/images/LoginPage.png)

![Root Page](/images/RootPage.png)

![Product Page](/images/ProductPage.png)


## Features to add:

- Adding a product.
- Adding a username from the app.
- Transfering ownership of a product to another user.
- Indicating on the Product Page when a product has changed owner.
- Adding a photo to a product.
- Adding a photo to a history entry.



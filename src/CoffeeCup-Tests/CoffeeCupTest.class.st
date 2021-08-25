Class {
	#name : #CoffeeCupTest,
	#superclass : #TestCase,
	#instVars : [
		'api'
	],
	#category : #'CoffeeCup-Tests'
}

{ #category : #initialization }
CoffeeCupTest class >> apiClass [

	^ TestableCoffeeCup
]

{ #category : #asserting }
CoffeeCupTest >> assertRequest: aRequest equalsUrl: anUrlOrString [

	self assert: aRequest url equals: anUrlOrString asUrl
]

{ #category : #initialization }
CoffeeCupTest >> setUp [

	| urlString |
	urlString := 'https://reqres.in/api'.
	api := self class apiClass baseUrl: urlString
]

{ #category : #tests }
CoffeeCupTest >> testAsCoffeeCupSelector [


	self
		assert: 'page' asCoffeeCupSelector equals: #page;
		assert: 'page_size' asCoffeeCupSelector equals: #pageSize;
		assert: 'Page-size' asCoffeeCupSelector equals: #pageSize
]

{ #category : #tests }
CoffeeCupTest >> testBaseUrl [

	self assert: api baseUrl equals: 'https://reqres.in/api' asUrl
]

{ #category : #tests }
CoffeeCupTest >> testDefaultOverwrite [

	(api parameter: 'api_key')
		required: true;
		default: 'INVALID-KEY'.
	api endpoint: #users.
	self
		assertRequest: (api usersPage: 2)
		equalsUrl: 'https://reqres.in/api/users?api_key=INVALID-KEY';
		assertRequest: (api usersApiKey: 1234)
		equalsUrl: 'https://reqres.in/api/users?api_key=1234'
]

{ #category : #tests }
CoffeeCupTest >> testEndpointBlock [

	"Optional parameters are only used if given."

	(api endpoint: #users) with: [ :endpoint | 
		(endpoint parameter: #page) with: [ :parameter | 
			parameter required: false ] ].

	self
		assertRequest: api users equalsUrl: 'https://reqres.in/api/users';
		assertRequest: (api usersPage: 2)
		equalsUrl: 'https://reqres.in/api/users?page=2'
]

{ #category : #tests }
CoffeeCupTest >> testEndpointCascade [

	"Optional parameters are only used if given."

	(api endpoint: #users) parameter: #page.

	self
		assertRequest: api users equalsUrl: 'https://reqres.in/api/users';
		assertRequest: (api usersPage: 2)
		equalsUrl: 'https://reqres.in/api/users?page=2'
]

{ #category : #tests }
CoffeeCupTest >> testMethodDefault [

	| ep |
	ep := (api endpoint: #users) .self assert: ep method equals: #get
]

{ #category : #tests }
CoffeeCupTest >> testOptionalParameter [

	"Optional parameters are only used if given."

	(api endpoint: #users) parameter: #page.

	self
		assertRequest: api users equalsUrl: 'https://reqres.in/api/users';
		assertRequest: (api usersPage: 2)
		equalsUrl: 'https://reqres.in/api/users?page=2'
]

{ #category : #tests }
CoffeeCupTest >> testParameterNaming [

	"Map API parameter names (e.g. 'page_size') to Smalltalk like names
	in the method selector (e.g. 'pageSize')"

	(api endpoint: #users) parameter: 'page_size'.

	self
		assertRequest: (api usersPageSize: 10)
		equalsUrl: 'https://reqres.in/api/users?page_size=10'
]

{ #category : #tests }
CoffeeCupTest >> testPathParameter [

	(api endpoint: #user) path: '/users/{id}'.
	self
		assertRequest: (api userId: 2)
		equalsUrl: 'https://reqres.in/api/users/2'
]

{ #category : #tests }
CoffeeCupTest >> testQueryParameter [

	(api endpoint: #users) with: [ :endpoint | 
		(endpoint parameter: #page) required: false ].
	self
		assertRequest: (api usersPage: 2)
		equalsUrl: 'https://reqres.in/api/users?page=2'
]

{ #category : #tests }
CoffeeCupTest >> testRequiredParameter [

	"Raise an error if required Parameter has no default and isn't given in the arguments"

	(api parameter: 'api_key') required: true.
	(api endpoint: #users) parameter: #page.
	self
		should: [ api usersPage: 2 ] raise: CoffeeCupError;
		shouldnt: [ api usersPage: 2 apiKey: '123' ]
		raise: CoffeeCupError
]

{ #category : #tests }
CoffeeCupTest >> testRequiredParameterWithDefault [

	"Don't raise an error if required Parameter a default "

	(api parameter: 'api_key')
		required: true;
		default: 123.
	(api endpoint: #users) parameter: #page.
	self shouldnt: [ api usersPage: 2 ] raise: CoffeeCupError
]

{ #category : #tests }
CoffeeCupTest >> testRestApiFormatParameters [


	self
		assertCollection: '/users/blah' coffeeCupFormatParameters
		hasSameElements: #(  );
		assertCollection: '/users/{foo}blah' coffeeCupFormatParameters
		hasSameElements: #( 'foo' );
		assertCollection: '/users/{foo}blah/{bar}' coffeeCupFormatParameters
		hasSameElements: #( 'foo' 'bar' )
]

{ #category : #tests }
CoffeeCupTest >> testSplitSelector [

	| ep |
	ep := api endpoint: #users.
	self
		assertCollection: (api splitSelector: #users) hasSameElements: { 
				ep.
				#(  ) };
		assertCollection: (api splitSelector: #usersPage:)
		hasSameElements: { 
				ep.
				#( #page ) };
					assertCollection: (api splitSelector: #usersPageSize:)
		hasSameElements: { 
				ep.
				#( #pageSize ) };
		assertCollection: (api splitSelector: #usersPage:pageSize:)
		hasSameElements: { 
				ep.
				#( #page #pageSize ) };
		assert: (api splitSelector: #postsPage:pageSize:) equals: nil
]

{ #category : #tests }
CoffeeCupTest >> testSuperflousArgument [

	"Verify that optional parameters are only used if given.
	Prevent superflous arguments from being used."

	(api endpoint: #users) parameter: #page.
	self
		assertRequest: (api usersFoo: 13)
		equalsUrl: 'https://reqres.in/api/users'
]

{ #category : #tests }
CoffeeCupTest >> testUnusedDefault [

	"Optional Parameters with defaults are kind of pointless and do not appear
	in the URL unless given as argument"

	((api endpoint: #users) parameter: #page) default: 2.

	self
		assertRequest: api users
		equalsUrl: 'https://reqres.in/api/users'
]

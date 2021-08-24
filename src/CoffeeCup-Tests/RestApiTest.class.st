Class {
	#name : #RestApiTest,
	#superclass : #TestCase,
	#instVars : [
		'api'
	],
	#category : #'CoffeeCup-Tests'
}

{ #category : #initialization }
RestApiTest class >> apiClass [

	^ TestableRestApi
]

{ #category : #asserting }
RestApiTest >> assertRequest: aRequest equals: anUrlOrString [

	self assert: aRequest url equals: anUrlOrString asUrl
]

{ #category : #initialization }
RestApiTest >> setUp [

	| urlString |
	urlString := 'https://reqres.in/api'.
	api := self class apiClass baseUrl: urlString
]

{ #category : #tests }
RestApiTest >> testBaseUrl [

	self assert: api baseUrl equals: 'https://reqres.in/api' asUrl
]

{ #category : #tests }
RestApiTest >> testDefaultOverwrite [

	(api parameter: 'api_key')
		required: true;
		default: 'INVALID-KEY'.
	api endpoint: 'users'.
	self
		assertRequest: (api users _getPage: 2)
		equals: 'https://reqres.in/api/users?api_key=INVALID-KEY';
		assertRequest: (api users _getApiKey: 1234)
		equals: 'https://reqres.in/api/users?api_key=1234'
]

{ #category : #tests }
RestApiTest >> testEndpointBlock [

	"Optional parameters are only used if given."

	(api endpoint: #users) with: [ :endpoint | 
		(endpoint parameter: #page) with: [ :parameter | 
			parameter required: false ] ].

	self
		assertRequest: api users _get equals: 'https://reqres.in/api/users';
		assertRequest: (api users _getPage: 2)
		equals: 'https://reqres.in/api/users?page=2'
]

{ #category : #tests }
RestApiTest >> testEndpointCascase [

	"Optional parameters are only used if given."

	(api endpoint: #users) parameter: #page.

	self
		assertRequest: api users _get equals: 'https://reqres.in/api/users';
		assertRequest: (api users _getPage: 2)
		equals: 'https://reqres.in/api/users?page=2'
]

{ #category : #tests }
RestApiTest >> testIsRestApiCall [

	self
		assert: #get isRestApiCall;
		assert: #getPage: isRestApiCall;
		assert: #getPage:pageSize: isRestApiCall;
		assert: #_getPage:pageSize: isRestApiCall
]

{ #category : #tests }
RestApiTest >> testOptionalParameter [

	"Optional parameters are only used if given."

	(api endpoint: #users) parameter: #page.
	
	self
		assertRequest: api users _get equals: 'https://reqres.in/api/users';
		assertRequest: (api users _getPage: 2)
		equals: 'https://reqres.in/api/users?page=2'
]

{ #category : #tests }
RestApiTest >> testParameterNaming [

	"Map API parameter names (e.g. 'page_size') to Smalltalk like names
	in the method selector (e.g. 'pageSize')"

	(api endpoint: #users) parameter: 'page_size' .
	
	self
		assertRequest: (api users _getPageSize: 10)
		equals: 'https://reqres.in/api/users?page_size=10'
]

{ #category : #tests }
RestApiTest >> testPathParameter [

	(api endpoint: #user) path: '/users/{id}'.
	self
		assertRequest: (api user _getId: 2)
		equals: 'https://reqres.in/api/users/2'
]

{ #category : #tests }
RestApiTest >> testQueryParameter [

	(api endpoint: #users) with: [ :endpoint | 
		(endpoint parameter: #page) required: false ].
	self
		assertRequest: (api users _getPage: 2)
		equals: 'https://reqres.in/api/users?page=2'
]

{ #category : #tests }
RestApiTest >> testRequiredParameter [

	"Raise an error if required Parameter has no default and isn't given in the arguments"

	(api parameter: 'api_key' )required: true.
	(api endpoint: #users) parameter: #page.
	self
		should: [ api users getPage: 2 ] raise: RestApiError;
		shouldnt: [ api users getPage: 2 apiKey: '123' ]
		raise: RestApiError
]

{ #category : #tests }
RestApiTest >> testRequiredParameterWithDefault [

	"Don't raise an error if required Parameter a default "

	(api parameter: 'api_key')
		required: true;
		default: 123.
	(api endpoint: #users)  parameter: #page .
	self shouldnt: [ api users getPage: 2 ] raise: RestApiError
]

{ #category : #tests }
RestApiTest >> testRestApiArgs [

	self
		assertCollection: #get restApiArgs hasSameElements: #(  );
		assertCollection: #getPage: restApiArgs
		hasSameElements: #( page );
		assertCollection: #getPage:pageSize: restApiArgs
	
		hasSameElements: #( page pageSize )
]

{ #category : #tests }
RestApiTest >> testRestApiFormatParameters [

	self
		assertCollection: '/users/blah' restApiFormatParameters hasSameElements: #(  );
		assertCollection: '/users/{foo}blah' restApiFormatParameters
		hasSameElements: #( 'foo' );
		assertCollection: '/users/{foo}blah/{bar}' restApiFormatParameters
		hasSameElements: #( 'foo' 'bar' )
]

{ #category : #tests }
RestApiTest >> testRestApiMethod [

	self
		assert: #get restApiMethod equals: #get;
		assert: #getPage: restApiMethod equals: #get;
		assert: #getPage:pageSize: restApiMethod equals: #get
]

{ #category : #tests }
RestApiTest >> testRestApiSelector [

	self
		assert: 'page' asRestApiSelector equals: #page;
		assert: 'page_size' asRestApiSelector equals: #pageSize;
		assert: 'Page-size' asRestApiSelector equals: #pageSize
]

{ #category : #tests }
RestApiTest >> testSuperflousArgument [

	"Verify that optional parameters are only used if given.
	Prevent superflous arguments from being used."

	(api
		endpoint: #users)
 parameter: #page  .
	self
		assertRequest: (api users _getFoo: 13)
		equals: 'https://reqres.in/api/users'
]

{ #category : #tests }
RestApiTest >> testUnusedDefault [

	"Optional Parameters with defaults are kind of pointless and do not appear
	in the URL unless given as argument"

	((api endpoint: #users)  
		 parameter: #page) default: 2 .

	self
		assertRequest: api users _getPage
		equals: 'https://reqres.in/api/users'
]

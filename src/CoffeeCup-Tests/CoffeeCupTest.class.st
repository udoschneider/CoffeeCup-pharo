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

	^ TestableCoffeeCupApi
]

{ #category : #asserting }
CoffeeCupTest >> assertRequest: aRequest equalsUrl: anUrlOrString [

	self assert: aRequest url equals: anUrlOrString asUrl
]

{ #category : #initialization }
CoffeeCupTest >> setUp [

	| urlString |
	urlString := 'https://ydlmz.mocklab.io'.
	api := self class apiClass baseUrl: urlString
]

{ #category : #tests }
CoffeeCupTest >> testApiPath [

	api := self class apiClass
		       baseUrl: 'https://ydlmz.mocklab.io'
		       do: [ :api2 | api2 path: 'api' ].

	self
		assert: api handler url
		equals: 'https://ydlmz.mocklab.io/api' asUrl
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

	self assert: api baseUrl equals: 'https://ydlmz.mocklab.io' asUrl
]

{ #category : #tests }
CoffeeCupTest >> testDefaultOverwrite [

	(api parameter: 'api_key')
		required: true;
		default: 'INVALID-KEY'.
	api endpoint: #users.
	self
		assertRequest: (api usersPage: 2)
		equalsUrl: 'https://ydlmz.mocklab.io/users?api_key=INVALID-KEY';
		assertRequest: (api usersApiKey: 1234)
		equalsUrl: 'https://ydlmz.mocklab.io/users?api_key=1234'
]

{ #category : #tests }
CoffeeCupTest >> testDescription [

	self
		shouldnt: [ 
			api
				description: 'Api Description';
				namespace: #foo do: [ :ns | 
					ns
						description: 'Namespace Description';
						endpoint: #bar do: [ :ep | 
							ep
								description: 'Endpoint Description';
								parameter: #baz
								do: [ :param | param description: 'Parameter Description' ] ] ] ]
		raise: Error
]

{ #category : #tests }
CoffeeCupTest >> testDocumentation [

	self shouldnt: [ 
		api
			description: 'Api Doc';
			namespace: #foo do: [ :ns | 
				ns
					description: 'Namespace Doc';
					endpoint: #bar do: [ :ep | 
						ep
							description: 'Endpoint Doc';
							parameter: #baz
							do: [ :param | param description: 'Parameter Doc' ] ] ] ] raise: Error
]

{ #category : #tests }
CoffeeCupTest >> testDocumentationForPathParameters [

	| parameter endpoint |
	api endpoint: #user do: [ :ep | 
		endpoint := ep path: '/users/{id}'.
		parameter := ep
			             parameter: #id
			             do: [ :id | id description: 'Document me!' ] ].
	self assert: endpoint queryParameters size equals: 0;
	assert: endpoint pathParameters size equals: 1;
	assert: (parameter isKindOf: CoffeeCupParameter );
	assert: parameter description equals: 'Document me!' 
]

{ #category : #tests }
CoffeeCupTest >> testEndpointBlock [

	"Optional parameters are only used if given."

	api endpoint: #users do: [ :endpoint | 
		endpoint parameter: #page do: [ :parameter | 
			parameter required: false ] ].

	self
		assertRequest: api users
		equalsUrl: 'https://ydlmz.mocklab.io/users';
		assertRequest: (api usersPage: 2)
		equalsUrl: 'https://ydlmz.mocklab.io/users?page=2'
]

{ #category : #tests }
CoffeeCupTest >> testEndpointCascade [

	"Optional parameters are only used if given."

	(api endpoint: #users) parameter: #page.

	self
		assertRequest: api users equalsUrl: 'https://ydlmz.mocklab.io/users';
		assertRequest: (api usersPage: 2)
		equalsUrl: 'https://ydlmz.mocklab.io/users?page=2'
]

{ #category : #tests }
CoffeeCupTest >> testFormatParameters [

	self
		assertCollection: '/users/blah' coffeeCupFormatParameters
		hasSameElements: #(  );
		assertCollection: '/users/{foo}blah' coffeeCupFormatParameters
		hasSameElements: #( #foo );
		assertCollection: '/users/{foo}blah/{bar}' coffeeCupFormatParameters
		hasSameElements: #( #foo #bar )
]

{ #category : #tests }
CoffeeCupTest >> testMethodDefault [

	| ep |
	ep := (api endpoint: #users) .self assert: ep method equals: #get
]

{ #category : #tests }
CoffeeCupTest >> testNamedArguments [

	api namespace: #foo do: [ :ns | 
		ns
			path: '{id}';
			endpoint: #bar do: [ :endpoint | endpoint path: '{id}' ] ].

	self
		assertRequest: ((api fooId: 1) barId: 2)
		equalsUrl: 'https://ydlmz.mocklab.io/1/2'
]

{ #category : #tests }
CoffeeCupTest >> testNamespace [

	api
		namespace: #namespace do: [ :ns | 
			ns
				path: '{id}';
				endpoint: #users do: [ :endpoint | 
					endpoint
						parameter: #page
						do: [ :parameter | parameter required: false ] ].
			ns namespace: #inner do: [ :innerNs | 
				innerNs endpoint: #users do: [ :endpoint | 
					endpoint
						parameter: #page
						do: [ :parameter | parameter required: false ] ] ] ];
		namespace: #outer do: [ :ns | ns endpoint: #things ].

	self
		assertRequest: (api namespaceId: #namespace) users
		equalsUrl: 'https://ydlmz.mocklab.io/namespace/users';
		assertRequest: ((api namespaceId: #namespace) usersPage: 2)
		equalsUrl: 'https://ydlmz.mocklab.io/namespace/users?page=2';
		assertRequest: ((api namespaceId: #namespace) inner usersPage: 2)
		equalsUrl:
			'https://ydlmz.mocklab.io/namespace/inner/users?page=2';
		assertRequest: api outer things
		equalsUrl: 'https://ydlmz.mocklab.io/outer/things'
]

{ #category : #tests }
CoffeeCupTest >> testOptionalParameter [

	"Optional parameters are only used if given."

	(api endpoint: #users) parameter: #page.

	self
		assertRequest: api users equalsUrl: 'https://ydlmz.mocklab.io/users';
		assertRequest: (api usersPage: 2)
		equalsUrl: 'https://ydlmz.mocklab.io/users?page=2'
]

{ #category : #tests }
CoffeeCupTest >> testParameterNaming [

	"Map API parameter names (e.g. 'page_size') to Smalltalk like names
	in the method selector (e.g. 'pageSize')"

	(api endpoint: #users) parameter: 'page_size'.

	self
		assertRequest: (api usersPageSize: 10)
		equalsUrl: 'https://ydlmz.mocklab.io/users?page_size=10'
]

{ #category : #tests }
CoffeeCupTest >> testPathParameter [

	(api endpoint: #user) path: '/users/{id}'.
	self
		assertRequest: (api userId: 2)
		equalsUrl: 'https://ydlmz.mocklab.io/users/2'
]

{ #category : #tests }
CoffeeCupTest >> testPathParameterReplacement [

	(api endpoint: #foobar) path: '/users/{id}';
	parameter: #id do: [ :parameter | parameter default: #bar ].
	self
		assert: ((api endpointAt: #foobar) pathParameterAt: #id) default
		equals: #bar
]

{ #category : #tests }
CoffeeCupTest >> testQueryParameter [

	api endpoint: #users do: [ :endpoint | 
		(endpoint parameter: #page) required: false ].
	self
		assertRequest: (api usersPage: 2)
		equalsUrl: 'https://ydlmz.mocklab.io/users?page=2'
]

{ #category : #tests }
CoffeeCupTest >> testQueryParameterReplacement [

	api endpoint: #foobar do: [ :endpoint | 
		(endpoint parameter: #foo) description: 'Desc';default: #bar.
		(endpoint parameter: #foo) default: #baz ].

	self
	assert: ((api endpointAt: #foobar) queryParameterAt: #foo) description
		equals: 'Desc';
		assert: ((api endpointAt: #foobar) queryParameterAt: #foo) default
		equals: #baz
]

{ #category : #tests }
CoffeeCupTest >> testRequiredParameter [

	"Raise an error if required Parameter has no default and isn't given in the arguments"

	api parameter: 'api_key' do: [ :param | param required: true ].
	(api endpoint: #users) parameter: #page.
	self
		should: [ api usersPage: 2 ] raise: CoffeeCupError;
		shouldnt: [ api usersPage: 2 apiKey: '123' ] raise: CoffeeCupError
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
		equalsUrl: 'https://ydlmz.mocklab.io/users'
]

{ #category : #tests }
CoffeeCupTest >> testUnnamedArguments [

	api namespace: #foo do: [ :ns | 
		ns
			path: '{id}';
			endpoint: #bar do: [ :endpoint | endpoint path: '{id}' ] ].

	self
		assertRequest: ((api foo: 1) bar: 2)
		equalsUrl: 'https://ydlmz.mocklab.io/1/2'
]

{ #category : #tests }
CoffeeCupTest >> testUnusedDefault [

	"Optional Parameters with defaults are kind of pointless and do not appear
	in the URL unless given as argument"

	((api endpoint: #users) parameter: #page) default: 2.

	self
		assertRequest: api users
		equalsUrl: 'https://ydlmz.mocklab.io/users'
]

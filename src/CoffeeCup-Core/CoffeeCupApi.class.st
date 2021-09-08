Class {
	#name : #CoffeeCupApi,
	#superclass : #CoffeeCupSpec,
	#instVars : [
		'baseUrl',
		'children'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #accessing }
CoffeeCupApi class >> baseUrl: aStringOrUrl [

	^ self new
		  setBaseUrl: aStringOrUrl;
		  yourself
]

{ #category : #accessing }
CoffeeCupApi class >> baseUrl: aStringOrUrl do: aBlock [
 ^(self baseUrl: aStringOrUrl ) do: aBlock
]

{ #category : #'as yet unclassified' }
CoffeeCupApi class >> librariesIo: apiKey [

	^ self baseUrl: 'https://libraries.io/api' do: [ :api | 
		  api
			  description: 'API for [Libraries.io](https://libraries.io/)';
			  documentation: 'https://libraries.io/api';
			  parameter: #api_key do: [ :param | 
				  param
					  description:
						  'get your api key from your account page: https://libraries.io/account';
					  required: true;
					  default: apiKey ];
			  parameter: #page
			  do: [ :param | param description: 'page (default 1)' ];
			  parameter: #per_page do: [ :param | 
			  param description:
				  'results per page (default is `30`, max is `100`)' ];
			  endpoint: #platforms do: [ :ep | 
			  ep
				  description: 'Get a list of supported package managers';
				  documentation: 'https://libraries.io/api#platforms' ];
			  namespace: #platform do: [ :platform | 
			  platform
				  path: '{id}';
				  namespace: #project do: [ :project | 
					  project
						  path: '{id}';
						  endpoint: #info do: [ :info | 
							  info
								  documentation:
									  'Get information about a package and it''s versions"';
								  path: '' ];
						  endpoint: #dependencies do: [ :dependencies | 
						  dependencies
							  description:
								  'Get a list of dependencies for a version of a project';
							  path: '/{version}/dependencies';
							  parameter: #version do: [ :version | version description: 'Project version' ] ];
						  endpoint: #dependents;
						  endpoint: #dependentRepositories;
						  endpoint: #contributors;
						  endpoint: #sourceRank;
						  endpoint: #usage ] ] ]
]

{ #category : #'double dispatch' }
CoffeeCupApi >> appendTo: aRequest with: arguments [

	^ aRequest copyAppendApi: self with: arguments
]

{ #category : #accessing }
CoffeeCupApi >> baseUrl [

	^ baseUrl
]

{ #category : #accessing }
CoffeeCupApi >> children [

	^ children
]

{ #category : #accessing }
CoffeeCupApi >> client [

	^ ZnClient new
]

{ #category : #'reflective operations' }
CoffeeCupApi >> doesNotUnderstand: aMessage [

	^ aMessage sendTo: self handler
]

{ #category : #configuration }
CoffeeCupApi >> endpoint: aSymbolOrString [

	| selector |
	selector := aSymbolOrString asCoffeeCupSelector.

	^ children
		  at: selector
		  put: (CoffeeCupEndpoint namespace: self name: selector)
]

{ #category : #configuration }
CoffeeCupApi >> endpoint: aSymbolOrString do: aBlock [

	^ (self endpoint: aSymbolOrString) do: aBlock
]

{ #category : #accessing }
CoffeeCupApi >> endpointAt: key [

	^ children at: key
]

{ #category : #private }
CoffeeCupApi >> handler [

	^ CoffeeCupHandler new copyAppend: self with: Dictionary new
]

{ #category : #initialization }
CoffeeCupApi >> initialize [

	super initialize.
	children := Dictionary new.

]

{ #category : #accessing }
CoffeeCupApi >> name: aString [
name := aString
]

{ #category : #configuration }
CoffeeCupApi >> namespace: aSymbolOrString [

	| selector |
	selector := aSymbolOrString asCoffeeCupSelector.

	^ children
		  at: selector
		  put: (CoffeeCupNamespace namespace: self name: selector)
]

{ #category : #configuration }
CoffeeCupApi >> namespace: aSymbolOrString do: aBlock [

	^ (self namespace: aSymbolOrString) do: aBlock
]

{ #category : #accessing }
CoffeeCupApi >> path [ 
^path ifNil: [ ^'' ]
]

{ #category : #printing }
CoffeeCupApi >> printOn: aStream [

	super printOn: aStream.
	aStream
		space;
		nextPut: $(;
		print: baseUrl;
		nextPut: $)
]

{ #category : #private }
CoffeeCupApi >> request: aRequest [

	^ self client
		  request: aRequest;
		  execute;response
]

{ #category : #initialization }
CoffeeCupApi >> setBaseUrl: aStringOrUrl [

	baseUrl := aStringOrUrl asUrl
]

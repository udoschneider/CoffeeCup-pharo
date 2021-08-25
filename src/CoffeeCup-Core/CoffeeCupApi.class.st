Class {
	#name : #CoffeeCupApi,
	#superclass : #CoffeeCupPathObject,
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
					  required: true;
					  default: apiKey;
					  description:
						  'get your api key from your account page: https://libraries.io/account' ];
			  parameter: #page
			  do: [ :param | param description: 'page (default 1)' ];
			  parameter: #per_page do: [ :param | 
			  param description:
				  'results per page (default is `30`, max is `100`)' ];
			  endpoint: #platforms do: [ :ep | 
			  ep
				  description: 'Get a list of supported package managers';
				  documentation: 'https://libraries.io/api#platforms' ] ;
			namespace: #platform do: [ :platform | ]]
]

{ #category : #accessing }
CoffeeCupApi >> allParameters [

	^ self pathParameters , self queryParameters
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

	^ (self splitSelector: aMessage selector)
		  ifNil: [ ^ super doesNotUnderstand: aMessage ]
		  ifNotNil: [ :splitted | 
			  | endpoint arguments |
			  endpoint := splitted first.
			  arguments := Dictionary
				               newFromKeys: splitted second
				               andValues: aMessage arguments.
			  endpoint callWith: arguments ]
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
CoffeeCupApi >> fullPath [

	^ self path
]

{ #category : #initialization }
CoffeeCupApi >> initialize [

	super initialize.
	children := Dictionary new.

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

{ #category : #configuration }
CoffeeCupApi >> parameter: aSymbolOrString [

	^queryParameters add:
		(CoffeeCupQueryParameter key: aSymbolOrString asCoffeeCupSelector name: aSymbolOrString)
]

{ #category : #configuration }
CoffeeCupApi >> parameter: aSymbolOrString do: aBlock [

	^ (self parameter: aSymbolOrString) do: aBlock
]

{ #category : #accessing }
CoffeeCupApi >> path [ 
^path ifNil: [ ^'' ]
]

{ #category : #'as yet unclassified' }
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
		  execute;
		  contents

]

{ #category : #initialization }
CoffeeCupApi >> setBaseUrl: aStringOrUrl [

	baseUrl := aStringOrUrl asUrl
]

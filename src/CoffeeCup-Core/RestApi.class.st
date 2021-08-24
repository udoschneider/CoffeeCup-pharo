Class {
	#name : #RestApi,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'endpoints',
		'parameters'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #accessing }
RestApi class >> baseUrl: aStringOrUrl [

	^ self new
		  baseUrl: aStringOrUrl;
		  yourself
]

{ #category : #'as yet unclassified' }
RestApi >> _endpoint: name path: path [

	^ self endpoint: name path: path with: nil
]

{ #category : #'as yet unclassified' }
RestApi >> _endpoint: name path: path with: aBlockOrNil [

	| endpoint |
	endpoint := endpoints
		            at: name asRestApiSelector
		            put: (RestApiEndpoint api: self name: name asSymbol).
	aBlockOrNil ifNotNil: [ :block | block value: endpoint ].
	^ endpoint
]

{ #category : #'as yet unclassified' }
RestApi >> _parameter: parameter required: aBoolean default: defaultValue [

	parameters add: (RestApiQueryParameter
			 key: parameter asRestApiSelector
			 name: parameter
			 required: aBoolean
			 default: defaultValue)
]

{ #category : #accessing }
RestApi >> baseUrl [

	^ baseUrl
]

{ #category : #accessing }
RestApi >> baseUrl: aStringOrUrl [

	baseUrl := aStringOrUrl asUrl
]

{ #category : #private }
RestApi >> client [

	^ ZnClient new
]

{ #category : #'reflective operations' }
RestApi >> doesNotUnderstand: aMessage [

	| endpointOrNamespace |
	endpointOrNamespace := aMessage selector splitCamelCase first
		                       asRestApiSelector.
	^ endpoints
		  at: endpointOrNamespace
		  ifPresent: [ :each | each ]
		  ifAbsentPut: [ super doesNotUnderstand: aMessage ]
]

{ #category : #'as yet unclassified' }
RestApi >> endpoint: aString [

	^ endpoints
		            at: aString asRestApiSelector
		            put:
		            (RestApiEndpoint
			             api: self
			             name: aString asRestApiSelector
			            ).
	
]

{ #category : #initialization }
RestApi >> initialize [

	super initialize.
	endpoints := Dictionary new.
	parameters := Set new
]

{ #category : #'as yet unclassified' }
RestApi >> parameter: aString [

	^parameters add:
		(RestApiQueryParameter key: aString asRestApiSelector name: aString)
]

{ #category : #accessing }
RestApi >> parameters [

	^ parameters
]

{ #category : #accessing }
RestApi >> request: aRequest [
^ self client
		  request: aRequest;
		  execute;
		  contents

]

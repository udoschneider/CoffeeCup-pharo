Class {
	#name : #CoffeeCup,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'endpoints',
		'parameters'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #accessing }
CoffeeCup class >> baseUrl: aStringOrUrl [

	^ self new
		  baseUrl: aStringOrUrl;
		  yourself
]

{ #category : #'as yet unclassified' }
CoffeeCup >> _endpoint: name path: path [

	^ self endpoint: name path: path with: nil
]

{ #category : #'as yet unclassified' }
CoffeeCup >> _endpoint: name path: path with: aBlockOrNil [

	| endpoint |
	endpoint := endpoints
		            at: name asCoffeeCupSelector
		            put: (CoffeeCupEndpoint api: self name: name asSymbol).
	aBlockOrNil ifNotNil: [ :block | block value: endpoint ].
	^ endpoint
]

{ #category : #'as yet unclassified' }
CoffeeCup >> _parameter: parameter required: aBoolean default: defaultValue [

	parameters add: (CoffeeCupQueryParameter
			 key: parameter asCoffeeCupSelector
			 name: parameter
			 required: aBoolean
			 default: defaultValue)
]

{ #category : #accessing }
CoffeeCup >> baseUrl [

	^ baseUrl
]

{ #category : #accessing }
CoffeeCup >> baseUrl: aStringOrUrl [

	baseUrl := aStringOrUrl asUrl
]

{ #category : #private }
CoffeeCup >> client [

	^ ZnClient new
]

{ #category : #'reflective operations' }
CoffeeCup >> doesNotUnderstand: aMessage [

	| endpointOrNamespace |
	endpointOrNamespace := aMessage selector splitCamelCase first
		                       asCoffeeCupSelector.
	^ endpoints
		  at: endpointOrNamespace
		  ifPresent: [ :each | each ]
		  ifAbsentPut: [ super doesNotUnderstand: aMessage ]
]

{ #category : #'as yet unclassified' }
CoffeeCup >> endpoint: aString [

	^ endpoints
		            at: aString asCoffeeCupSelector
		            put:
		            (CoffeeCupEndpoint
			             api: self
			             name: aString asCoffeeCupSelector
			            ).
	
]

{ #category : #initialization }
CoffeeCup >> initialize [

	super initialize.
	endpoints := Dictionary new.
	parameters := Set new
]

{ #category : #'as yet unclassified' }
CoffeeCup >> parameter: aString [

	^parameters add:
		(CoffeeCupQueryParameter key: aString asCoffeeCupSelector name: aString)
]

{ #category : #accessing }
CoffeeCup >> parameters [

	^ parameters
]

{ #category : #accessing }
CoffeeCup >> request: aRequest [
^ self client
		  request: aRequest;
		  execute;
		  contents

]

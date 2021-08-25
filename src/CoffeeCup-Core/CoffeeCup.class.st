Class {
	#name : #CoffeeCup,
	#superclass : #Object,
	#instVars : [
		'baseUrl',
		'endpoints',
		'queryParameters'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #accessing }
CoffeeCup class >> baseUrl: aStringOrUrl [

	^ self new
		  baseUrl: aStringOrUrl;
		  yourself
]

{ #category : #deprecated }
CoffeeCup >> _doesNotUnderstand: aMessage [

	| endpointOrNamespace |
	endpointOrNamespace := aMessage selector splitCamelCase first
		                       asCoffeeCupSelector.
	^ endpoints
		  at: endpointOrNamespace
		  ifPresent: [ :each | each ]
		  ifAbsentPut: [ super doesNotUnderstand: aMessage ]
]

{ #category : #deprecated }
CoffeeCup >> _endpoint: name path: path [

	^ self endpoint: name path: path with: nil
]

{ #category : #deprecated }
CoffeeCup >> _endpoint: name path: path with: aBlockOrNil [

	| endpoint |
	endpoint := endpoints
		            at: name asCoffeeCupSelector
		            put: (CoffeeCupEndpoint namespace: self name: name asSymbol).
	aBlockOrNil ifNotNil: [ :block | block value: endpoint ].
	^ endpoint
]

{ #category : #deprecated }
CoffeeCup >> _parameter: parameter required: aBoolean default: defaultValue [

	queryParameters add: (CoffeeCupQueryParameter
			 key: parameter asCoffeeCupSelector
			 name: parameter
			 required: aBoolean
			 default: defaultValue)
]

{ #category : #accessing }
CoffeeCup >> allParameters [ 
^queryParameters 
]

{ #category : #accessing }
CoffeeCup >> baseUrl [

	^ baseUrl
]

{ #category : #accessing }
CoffeeCup >> baseUrl: aStringOrUrl [

	baseUrl := aStringOrUrl asUrl
]

{ #category : #accessing }
CoffeeCup >> client [

	^ ZnClient new
]

{ #category : #'reflective operations' }
CoffeeCup >> doesNotUnderstand: aMessage [

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
CoffeeCup >> endpoint: aSymbolOrString [

	| selector |
	selector := aSymbolOrString asCoffeeCupSelector.

	^ endpoints
		  at: selector
		  put: (CoffeeCupEndpoint namespace: self name: selector)
]

{ #category : #initialization }
CoffeeCup >> initialize [

	super initialize.
	endpoints := Dictionary new.
	queryParameters := Set new
]

{ #category : #configuration }
CoffeeCup >> parameter: aString [

	^queryParameters add:
		(CoffeeCupQueryParameter key: aString asCoffeeCupSelector name: aString)
]

{ #category : #accessing }
CoffeeCup >> queryParameters [

	^ queryParameters
]

{ #category : #private }
CoffeeCup >> request: aRequest [
^ self client
		  request: aRequest;
		  execute;
		  contents

]

{ #category : #private }
CoffeeCup >> splitSelector: selector [

	| splitted arguments |
	splitted := ($: split: selector) select: #notEmpty.

	arguments := splitted allButFirst.

	splitted := splitted first splitCamelCase.
	1 to: splitted size do: [ :index | 
		| possibleSelector |
		possibleSelector := ('' join: (splitted copyFrom: 1 to: index))
			                    asCoffeeCupSelector.

		endpoints at: possibleSelector ifPresent: [ :endpoint | 
			| firstArgument |
			firstArgument := { ('' join: (splitted allButFirst: index)) }.
			arguments := (firstArgument , arguments
				              select: #notEmpty
				              thenCollect: [ :each | each asCoffeeCupSelector ])
				             asArray.
			^ { 
				  endpoint.
				  arguments } ] ].
	^ nil
]

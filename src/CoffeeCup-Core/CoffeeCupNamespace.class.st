Class {
	#name : #CoffeeCupNamespace,
	#superclass : #CoffeeCupPathObject,
	#instVars : [
		'namespace',
		'name',
		'children'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #'instance creation' }
CoffeeCupNamespace class >> namespace: aNamespace name: aSymbol [

	^ self new
		  setNamespace: aNamespace name: aSymbol;
		  yourself
]

{ #category : #accessing }
CoffeeCupNamespace >> allParameters [

	^ namespace allParameters , pathParameters , queryParameters
]

{ #category : #accessing }
CoffeeCupNamespace >> baseUrl [

	^ namespace baseUrl
]

{ #category : #private }
CoffeeCupNamespace >> callWith: arguments [
arguments notEmpty ifTrue: [ CoffeeCupError signal: 'Arguments for namespaces must not be provided!' ].
	^ self
]

{ #category : #accessing }
CoffeeCupNamespace >> children [ ^children
]

{ #category : #'reflective operations' }
CoffeeCupNamespace >> doesNotUnderstand: aMessage [

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
CoffeeCupNamespace >> endpoint: aSymbolOrString [

	| selector |
	selector := aSymbolOrString asCoffeeCupSelector.

	^ children
		  at: selector
		  put: (CoffeeCupEndpoint namespace: self name: selector)
]

{ #category : #configuration }
CoffeeCupNamespace >> endpoint: aSymbolOrString do: aBlock [

	^ (self endpoint: aSymbolOrString) do: aBlock
]

{ #category : #accessing }
CoffeeCupNamespace >> fullPath [

	^ namespace fullPath , '/' , self path
]

{ #category : #initialization }
CoffeeCupNamespace >> initialize [

	super initialize.
	children := Dictionary new.

]

{ #category : #accessing }
CoffeeCupNamespace >> name [

	^ name
]

{ #category : #accessing }
CoffeeCupNamespace >> namespace [

	^ namespace
]

{ #category : #configuration }
CoffeeCupNamespace >> namespace: aSymbolOrString [

	| selector |
	selector := aSymbolOrString asCoffeeCupSelector.

	^ children
		  at: selector
		  put: (CoffeeCupNamespace namespace: self name: selector)
]

{ #category : #configuration }
CoffeeCupNamespace >> namespace: aSymbolOrString do: aBlock [

	^ (self namespace: aSymbolOrString) do: aBlock
]

{ #category : #accessing }
CoffeeCupNamespace >> path [

	^ path ifNil: [ name asString ]
]

{ #category : #accessing }
CoffeeCupNamespace >> request: request [

	^ namespace request: request
]

{ #category : #initialization }
CoffeeCupNamespace >> setNamespace: aNamespace name: aSymbol [

	namespace := aNamespace.
	name := aSymbol
]

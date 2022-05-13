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

{ #category : #visiting }
CoffeeCupApi >> acceptVisitor: aVisitor [

	^ aVisitor visitApi: self
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

{ #category : #accessing }
CoffeeCupApi >> fullPath [

	^ baseUrl asString
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

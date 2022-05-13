Class {
	#name : #CoffeeCupNamespace,
	#superclass : #CoffeeCupSpec,
	#instVars : [
		'namespace',
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

{ #category : #visiting }
CoffeeCupNamespace >> acceptVisitor: aVisitor [

	^ aVisitor visitNamespace: self
]

{ #category : #'double dispatech' }
CoffeeCupNamespace >> appendTo: aRequest with: arguments [

	^ aRequest copyAppendNamespace: self with: arguments
]

{ #category : #accessing }
CoffeeCupNamespace >> children [ ^children
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
CoffeeCupNamespace >> endpointAt: key [

	^ children at: key
]

{ #category : #accessing }
CoffeeCupNamespace >> fullPath [

	^ path
		  ifNil: [ namespace fullPath ]
		  ifNotNil: [ namespace fullPath , '/' , path ]
]

{ #category : #initialization }
CoffeeCupNamespace >> initialize [

	super initialize.
	children := Dictionary new.

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

{ #category : #printing }
CoffeeCupNamespace >> printOn: aStream [

	super printOn: aStream.
	aStream
		space;
		nextPut: $(;
		print: name;
		nextPut: $)
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

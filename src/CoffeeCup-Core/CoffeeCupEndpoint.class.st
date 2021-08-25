Class {
	#name : #CoffeeCupEndpoint,
	#superclass : #CoffeeCupSpec,
	#instVars : [
		'namespace',
		'name'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #'instance creation' }
CoffeeCupEndpoint class >> namespace: aNamespace name: aSymbol [

	^ self new
		  setNamespace: aNamespace name: aSymbol;
		  yourself
]

{ #category : #'double dispatch' }
CoffeeCupEndpoint >> appendTo: aRequest with: arguments [ 
	^aRequest copyAppendEndpoint: self with: arguments 
]

{ #category : #accessing }
CoffeeCupEndpoint >> method [

^#get
]

{ #category : #configuration }
CoffeeCupEndpoint >> parameter: aSymbolOrString [

	^ pathParameters
		  detect: [ :each | each name = aSymbolOrString ]
		  ifFound: [ :parameter | parameter ]
		  ifNone: [ 
			  queryParameters add: (CoffeeCupQueryParameter
					   key: aSymbolOrString asCoffeeCupSelector
					   name: aSymbolOrString) ]
]

{ #category : #configuration }
CoffeeCupEndpoint >> parameter: aSymbolOrString do: aBlock [
^(self parameter: aSymbolOrString ) do: aBlock
]

{ #category : #accessing }
CoffeeCupEndpoint >> path [

	^ path ifNil: [ name asString ]
]

{ #category : #printing }
CoffeeCupEndpoint >> printOn: aStream [

	super printOn: aStream.
	aStream
		space;
		nextPut: $(;
		print: name;
		nextPut: $)
]

{ #category : #private }
CoffeeCupEndpoint >> request: request [

	^ namespace request: request
]

{ #category : #initialization }
CoffeeCupEndpoint >> setNamespace: aNamespace name: aSymbol [

	namespace := aNamespace.
	name := aSymbol.
	
]

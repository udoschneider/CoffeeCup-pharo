Class {
	#name : #CoffeeCupEndpoint,
	#superclass : #CoffeeCupSpec,
	#instVars : [
		'namespace'
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
CoffeeCupEndpoint >> children [
^#()
]

{ #category : #accessing }
CoffeeCupEndpoint >> method [

^#get
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

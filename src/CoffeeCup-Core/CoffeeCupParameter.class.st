Class {
	#name : #CoffeeCupParameter,
	#superclass : #Object,
	#instVars : [
		'key',
		'name',
		'default'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #'instance creation' }
CoffeeCupParameter class >> key: aSymbol name: aString [

	^ self new setKey: aSymbol name: aString; yourself
]

{ #category : #comparing }
CoffeeCupParameter >> = anObject [

	^ anObject class = self class
		  ifFalse: [ false ]
		  ifTrue: [ anObject key = self key ]
]

{ #category : #accessing }
CoffeeCupParameter >> default [
	^ default
]

{ #category : #accessing }
CoffeeCupParameter >> default: aString [ 
	default := aString
]

{ #category : #comparing }
CoffeeCupParameter >> hash [

	^ key hash
]

{ #category : #initialization }
CoffeeCupParameter >> initialize [

	super initialize.

	default := nil
]

{ #category : #testing }
CoffeeCupParameter >> isPathParameter [

	^ false
]

{ #category : #testing }
CoffeeCupParameter >> isQueryParameter [

	^ false
]

{ #category : #testing }
CoffeeCupParameter >> isRequired [

	self subclassResponsibility 
]

{ #category : #accessing }
CoffeeCupParameter >> key [
	^ key
]

{ #category : #accessing }
CoffeeCupParameter >> name [
	^ name
]

{ #category : #printing }
CoffeeCupParameter >> printOn: aStream [

	super printOn: aStream.

	aStream
		space;
		nextPut: $(;
		nextPutAll: name;
	
		nextPut: $)
]

{ #category : #initialization }
CoffeeCupParameter >> setKey: aSymbol name: aString [ 

	key := aSymbol.
	name := aString.
	
]

{ #category : #configuration }
CoffeeCupParameter >> with: aBlockOrNil [

	aBlockOrNil ifNotNil: [ :block | block value: self ]
]

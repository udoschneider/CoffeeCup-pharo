Class {
	#name : #CoffeeCupParameter,
	#superclass : #Object,
	#instVars : [
		'key',
		'name',
		'default',
		'description',
		'documentation'
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

{ #category : #accessing }
CoffeeCupParameter >> description: aString [

	description := aString
]

{ #category : #configuration }
CoffeeCupParameter >> do: aBlockOrNil [

	aBlockOrNil ifNotNil: [ :block | block value: self ]
]

{ #category : #accessing }
CoffeeCupParameter >> documentation [
	^ documentation
]

{ #category : #accessing }
CoffeeCupParameter >> documentation: aString [ 
	documentation := aString
]

{ #category : #comparing }
CoffeeCupParameter >> hash [

	^ key hash
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
		print: name;
		nextPut: $)
]

{ #category : #initialization }
CoffeeCupParameter >> setKey: aSymbol name: aString [ 

	key := aSymbol.
	name := aString.
	
]

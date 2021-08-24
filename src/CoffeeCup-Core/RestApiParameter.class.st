Class {
	#name : #RestApiParameter,
	#superclass : #Object,
	#instVars : [
		'key',
		'name',
		'default'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #'instance creation' }
RestApiParameter class >> key: aSymbol name: aString [

	^ self new key: aSymbol setName: aString; yourself
]

{ #category : #comparing }
RestApiParameter >> = anObject [

	^ anObject class = self class
		  ifFalse: [ false ]
		  ifTrue: [ anObject key = self key ]
]

{ #category : #accessing }
RestApiParameter >> default [
	^ default
]

{ #category : #accessing }
RestApiParameter >> default: aString [ 
	default := aString
]

{ #category : #comparing }
RestApiParameter >> hash [

	^ key hash
]

{ #category : #initialization }
RestApiParameter >> initialize [

	super initialize.

	default := nil
]

{ #category : #testing }
RestApiParameter >> isPathParameter [

	^ false
]

{ #category : #testing }
RestApiParameter >> isQueryParameter [

	^ false
]

{ #category : #testing }
RestApiParameter >> isRequired [

	self subclassResponsibility 
]

{ #category : #accessing }
RestApiParameter >> key [
	^ key
]

{ #category : #initialization }
RestApiParameter >> key: aSymbol setName: aString [ 

	key := aSymbol.
	name := aString.
	
]

{ #category : #accessing }
RestApiParameter >> name [
	^ name
]

{ #category : #printing }
RestApiParameter >> printOn: aStream [

	super printOn: aStream.

	aStream
		space;
		nextPut: $(;
		nextPutAll: name;
	
		nextPut: $)
]

{ #category : #'instance creation' }
RestApiParameter >> with: aBlockOrNil [

	aBlockOrNil ifNotNil: [ :block | block value: self ]
]

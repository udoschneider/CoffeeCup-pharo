Class {
	#name : #CoffeeCupParameter,
	#superclass : #Object,
	#instVars : [
		'key',
		'name',
		'properties'
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

	^ self propertyAt: #default default: nil
]

{ #category : #accessing }
CoffeeCupParameter >> default: aString [

	^self propertyAt: #default put: aString 
]

{ #category : #accessing }
CoffeeCupParameter >> description [

	^ self propertyAt: #description default: nil
]

{ #category : #accessing }
CoffeeCupParameter >> description: aString [

		^ self propertyAt: #description put: aString
]

{ #category : #configuration }
CoffeeCupParameter >> do: aBlockOrNil [

	aBlockOrNil ifNotNil: [ :block | block value: self ]
]

{ #category : #'as yet unclassified' }
CoffeeCupParameter >> documentationOn: stream [

	self url
		ifNotNil: [ 
			stream
				nextPut: $[;
				nextPutAll: '`';
				nextPutAll: self name;
				nextPutAll: '`: ';
				nextPutAll: '](';
				nextPutAll: self url;
				nextPut: $)
			 ]
		ifNil: [ 
			stream
				nextPutAll: '`';
				nextPutAll: self name;
				nextPutAll: '`: '
			 ].
	self description ifNotNil: [ :value | stream nextPutAll: value ]
]

{ #category : #'as yet unclassified' }
CoffeeCupParameter >> documentationString [

	^ String streamContents: [ :stream | 
		 self documentationOn: stream]
]

{ #category : #comparing }
CoffeeCupParameter >> hash [

	^ key hash
]

{ #category : #initialization }
CoffeeCupParameter >> initialize [ 
super initialize .
properties := Dictionary new
]

{ #category : #'as yet unclassified' }
CoffeeCupParameter >> inspectionDocumentation [

	<inspectorPresentationOrder: 10000 title: 'Documentation'>
	^ SpTextPresenter new
		  text: self documentationString;
		  yourself
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
CoffeeCupParameter >> propertyAt: aKey default: aValue [

	^ properties at: aKey ifAbsent: [ aValue  ]
]

{ #category : #initialization }
CoffeeCupParameter >> propertyAt: aKey put: aValue [

	^ properties at: aKey put: aValue
]

{ #category : #initialization }
CoffeeCupParameter >> setKey: aSymbol name: aString [ 

	key := aSymbol.
	name := aString.
	
]

{ #category : #accessing }
CoffeeCupParameter >> title [

	^ self propertyAt: #title default: nil
]

{ #category : #accessing }
CoffeeCupParameter >> title: aString [

	^ self propertyAt: #title put: aString
]

{ #category : #accessing }
CoffeeCupParameter >> url [

	^ self propertyAt: #url default: nil
]

{ #category : #accessing }
CoffeeCupParameter >> url: aString [

	^ self propertyAt: #url put: aString
]

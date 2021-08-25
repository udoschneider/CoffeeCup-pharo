Class {
	#name : #CoffeeCupPathObject,
	#superclass : #Object,
	#instVars : [
		'path',
		'pathParameters',
		'queryParameters',
		'description',
		'documentation'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #accessing }
CoffeeCupPathObject >> allParameters [

	self subclassResponsibility
]

{ #category : #accessing }
CoffeeCupPathObject >> description: aString [

	description := aString
]

{ #category : #'instance creation' }
CoffeeCupPathObject >> do: aBlockOrNil [

	aBlockOrNil ifNotNil: [ :block | block value: self ]
]

{ #category : #accessing }
CoffeeCupPathObject >> documentation: aString [

	documentation := aString
]

{ #category : #accessing }
CoffeeCupPathObject >> fullPath [

	self subclassResponsibility
]

{ #category : #initialization }
CoffeeCupPathObject >> initialize [

super initialize .
	pathParameters := Set new.
	queryParameters := Set new
]

{ #category : #accessing }
CoffeeCupPathObject >> path [
self subclassResponsibility 
]

{ #category : #configuration }
CoffeeCupPathObject >> path: aString [

	path := aString.

	pathParameters := (path coffeeCupFormatParameters collect: [ 
		                   :pathParameter | 
		                   CoffeeCupPathParameter
			                   key: pathParameter asCoffeeCupSelector
			                   name: pathParameter ]) asSet
]

{ #category : #accessing }
CoffeeCupPathObject >> pathParameters [

	^ pathParameters
]

{ #category : #accessing }
CoffeeCupPathObject >> queryParameters [

	^ queryParameters
]

{ #category : #accessing }
CoffeeCupPathObject >> request: request [

	self subclassResponsibility 
]

{ #category : #private }
CoffeeCupPathObject >> splitSelector: selector [

	| splitted arguments |
	splitted := ($: split: selector) select: #notEmpty.

	arguments := splitted allButFirst.

	splitted := splitted first splitCamelCase.
	1 to: splitted size do: [ :index | 
		| possibleSelector |
		possibleSelector := ('' join: (splitted copyFrom: 1 to: index))
			                    asCoffeeCupSelector.

		self children at: possibleSelector ifPresent: [ :endpoint | 
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

Class {
	#name : #CoffeeCupSpec,
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

{ #category : #'double dispatch' }
CoffeeCupSpec >> appendTo: aRequest with: arguments [

	self subclassResponsibility
]

{ #category : #accessing }
CoffeeCupSpec >> description: aString [

	description := aString
]

{ #category : #'instance creation' }
CoffeeCupSpec >> do: aBlockOrNil [

	aBlockOrNil ifNotNil: [ :block | block value: self ]
]

{ #category : #accessing }
CoffeeCupSpec >> documentation: aString [

	documentation := aString
]

{ #category : #initialization }
CoffeeCupSpec >> initialize [

super initialize .
	pathParameters := Set new.
	queryParameters := Set new
]

{ #category : #accessing }
CoffeeCupSpec >> path [
self subclassResponsibility 
]

{ #category : #configuration }
CoffeeCupSpec >> path: aString [

	path := aString.

	pathParameters := (path coffeeCupFormatParameters collect: [ 
		                   :pathParameter | 
		                   CoffeeCupPathParameter
			                   key: pathParameter asCoffeeCupSelector
			                   name: pathParameter ]) asSet
]

{ #category : #accessing }
CoffeeCupSpec >> pathParameters [

	^ pathParameters
]

{ #category : #accessing }
CoffeeCupSpec >> queryParameters [

	^ queryParameters
]

{ #category : #accessing }
CoffeeCupSpec >> request: request [

	self subclassResponsibility 
]

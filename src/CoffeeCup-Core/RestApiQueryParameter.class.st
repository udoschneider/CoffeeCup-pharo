Class {
	#name : #RestApiQueryParameter,
	#superclass : #RestApiParameter,
	#instVars : [
		'required'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #initialization }
RestApiQueryParameter >> initialize [

	super initialize.
	required := false
]

{ #category : #testing }
RestApiQueryParameter >> isQueryParameter [

	^ true
]

{ #category : #testing }
RestApiQueryParameter >> isRequired [

	^ required
]

{ #category : #accessing }
RestApiQueryParameter >> required: aBoolean [ 
	required := aBoolean
]

Class {
	#name : #RestApiPathParameter,
	#superclass : #RestApiParameter,
	#category : #'CoffeeCup-Core'
}

{ #category : #testing }
RestApiPathParameter >> isPathParameter [

	^ true
]

{ #category : #testing }
RestApiPathParameter >> isRequired [

^true	
]

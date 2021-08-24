Class {
	#name : #RestApiResources,
	#superclass : #TestResource,
	#instVars : [
		'cache'
	],
	#category : #'CoffeeCup-Tests'
}

{ #category : #initialization }
RestApiResources >> initialize [

	super initialize.
	cache := TTLCache new
]

{ #category : #initialization }
RestApiResources >> request: aUrl [

	^cache at: aUrl ifAbsentPut: [ (ZnEasy get: aUrl) contents ]
]

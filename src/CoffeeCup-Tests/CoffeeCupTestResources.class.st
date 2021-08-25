Class {
	#name : #CoffeeCupTestResources,
	#superclass : #TestResource,
	#instVars : [
		'cache'
	],
	#category : #'CoffeeCup-Tests'
}

{ #category : #initialization }
CoffeeCupTestResources >> initialize [

	super initialize.
	cache := TTLCache new
]

{ #category : #initialization }
CoffeeCupTestResources >> request: aUrl [

	^cache at: aUrl ifAbsentPut: [ (ZnEasy get: aUrl) contents ]
]

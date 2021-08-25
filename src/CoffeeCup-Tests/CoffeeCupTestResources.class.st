Class {
	#name : #CoffeeCupTestResources,
	#superclass : #TestResource,
	#classVars : [
		'Cache'
	],
	#category : #'CoffeeCup-Tests'
}

{ #category : #origins }
CoffeeCupTestResources class >> cache [ 
^Cache ifNil: [ 	Cache := TTLCache new ]
]

{ #category : #initialization }
CoffeeCupTestResources >> request: aUrl [

	^ self class cache
		  at: aUrl
		  ifAbsentPut: [ (ZnEasy get: aUrl) contents ]
]

Class {
	#name : #CoffeeCupQueryParameter,
	#superclass : #CoffeeCupParameter,
	#instVars : [
		'required'
	],
	#category : #'CoffeeCup-Core'
}

{ #category : #initialization }
CoffeeCupQueryParameter >> initialize [

	super initialize.
	required := false
]

{ #category : #testing }
CoffeeCupQueryParameter >> isQueryParameter [

	^ true
]

{ #category : #testing }
CoffeeCupQueryParameter >> isRequired [

	^ required
]

{ #category : #accessing }
CoffeeCupQueryParameter >> required: aBoolean [ 
	required := aBoolean
]

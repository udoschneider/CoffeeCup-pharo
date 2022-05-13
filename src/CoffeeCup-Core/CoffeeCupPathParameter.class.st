Class {
	#name : #CoffeeCupPathParameter,
	#superclass : #CoffeeCupParameter,
	#category : #'CoffeeCup-Core'
}

{ #category : #visiting }
CoffeeCupPathParameter >> acceptVisitor: aVisitor [

	^ aVisitor visitPathParameter: self
]

{ #category : #testing }
CoffeeCupPathParameter >> isRequired [

^true	
]

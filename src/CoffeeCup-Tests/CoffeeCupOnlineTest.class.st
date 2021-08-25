Class {
	#name : #CoffeeCupOnlineTest,
	#superclass : #CoffeeCupTest,
	#classVars : [
		'ApiKey'
	],
	#category : #'CoffeeCup-Tests'
}

{ #category : #initialization }
CoffeeCupOnlineTest class >> apiClass [

	^ CoffeeCup
]

{ #category : #accessing }
CoffeeCupOnlineTest class >> apiKey [

^ApiKey ifNil: [ ApiKey := 
	UIManager default request: 'Libraries.IO API Key']
]

{ #category : #accessing }
CoffeeCupOnlineTest class >> resources [

	^ super resources copyWith: CoffeeCupTestResources
]

{ #category : #asserting }
CoffeeCupOnlineTest >> assertRequest: aString equals: aUrl [

	self assert: aString equals: (CoffeeCupTestResources current request: aUrl)
]

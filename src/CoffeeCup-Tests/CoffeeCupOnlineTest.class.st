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

	^ CoffeeCupApi
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
CoffeeCupOnlineTest >> assertRequest: aResponse equalsUrl: aUrl [

	self
		assert: aResponse contents
		equals: (CoffeeCupTestResources current request: aUrl)
]

Class {
	#name : #RestApiOnlineTest,
	#superclass : #RestApiTest,
	#classVars : [
		'ApiKey'
	],
	#category : #'CoffeeCup-Tests'
}

{ #category : #initialization }
RestApiOnlineTest class >> apiClass [

	^ RestApi
]

{ #category : #accessing }
RestApiOnlineTest class >> apiKey [

^ApiKey ifNil: [ ApiKey := 
	UIManager default request: 'Libraries.IO API Key']
]

{ #category : #accessing }
RestApiOnlineTest class >> resources [

	^ super resources copyWith: RestApiResources
]

{ #category : #asserting }
RestApiOnlineTest >> assertRequest: aString equals: aUrl [

	self assert: aString equals: (RestApiResources current request: aUrl)
]

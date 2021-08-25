Extension { #name : #String }

{ #category : #'*CoffeeCup-Core' }
String >> asCoffeeCupSelector [

	^self asSymbol asCoffeeCupSelector
]

{ #category : #'*CoffeeCup-Core' }
String >> coffeeCupFormatParameters [

	^ OrderedCollection streamContents: [ :result | 
		  | stream |
		  stream := self readStream.
		  [ stream atEnd ] whileFalse: [ 
			  | currentChar |
			  (currentChar := stream next) == ${
				  ifTrue: [ 
					  | expression |
					  expression := stream upTo: $}.
					  result nextPut: expression asSymbol  ]
				  ifFalse: [ 
				  currentChar == $\ ifTrue: [ 
					  stream atEnd ifFalse: [ stream next ] ] ] ] ]
]

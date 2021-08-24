Extension { #name : #Symbol }

{ #category : #'*CoffeeCup-Core' }
Symbol >> asRestApiSelector [

	^ (Character space join:
		   ([ :each | each isAlphaNumeric not ] split: self)) asCamelCase uncapitalized 
		  asValidSelector
]

{ #category : #'*CoffeeCup-Core' }
Symbol >> restApiArgs [

	| arguments |
	self isUnary ifTrue: [ ^ #(  ) ].
	arguments := ($: split: self) select: [ :each | each notEmpty ].

	^ arguments
		  ifNotEmpty: [ 
			  arguments at: 1 put: ('' join: arguments first splitCamelCase allButFirst).
			  arguments collect: [ :each | each asRestApiSelector ] ]
		  ifEmpty: [ #(  ) ]
]

{ #category : #'*CoffeeCup-Core' }
Symbol >> restApiMethod [

	^ self splitCamelCase first 
]

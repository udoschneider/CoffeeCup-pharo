Extension { #name : #Symbol }

{ #category : #'*CoffeeCup-Core' }
Symbol >> _coffeeCupArguments [

	| arguments |
	self isUnary ifTrue: [ ^ #(  ) ].
	arguments := ($: split: self) select: [ :each | each notEmpty ].

	^ arguments
		  ifNotEmpty: [ 
			  arguments
				  at: 1
				  put: ('' join: arguments first splitCamelCase allButFirst).
			  arguments collect: [ :each | each asCoffeeCupSelector ] ]
		  ifEmpty: [ #(  ) ]
]

{ #category : #'*CoffeeCup-Core' }
Symbol >> _isRestApiCall [

	^ (self isKeyword or: [ self isUnary ]) and: [ 
		  #( get ) includes: self coffeeCupMethod asCoffeeCupSelector ]
]

{ #category : #'*CoffeeCup-Core' }
Symbol >> asCoffeeCupSelector [

	^ (Character space join:
		   ([ :each | each isAlphaNumeric not ] split: self)) asCamelCase uncapitalized 
		  asValidSelector
]

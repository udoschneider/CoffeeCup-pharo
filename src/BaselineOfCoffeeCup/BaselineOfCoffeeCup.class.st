Class {
	#name : #BaselineOfCoffeeCup,
	#superclass : #BaselineOf,
	#category : #BaselineOfCoffeeCup
}

{ #category : #baselines }
BaselineOfCoffeeCup >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec package: #'CoffeeCup-Core'.
		spec
			package: #'CoffeeCup-Tests'
			with: [ spec requires: #( #'CoffeeCup-Core' ) ];
			group: 'default' with: #( core tests );
			group: 'core' with: #( #'CoffeeCup-Core' );
			group: 'tests' with: #( #'CoffeeCup-Tests' ) ]
]

<script lang="ts">
	import { tooltip } from '@svelte-plugins/tooltips';
	import 'bootstrap/dist/css/bootstrap.min.css';

	function bin(n: number): string {
		const binNum = n.toString(2);
		const groups = binNum
			.split('')
			.reverse()
			.join('')
			.match(/.{1,4}/g);
		if (groups) {
			return groups.join("'").split('').reverse().join('');
		} else {
			return '';
		}
	}

	function hex(n: number): string {
		return n.toString(16).toUpperCase();
	}

	export let data: {
		dec2bin: number[];
		bin2dec: number[];
		addition: [number, number][];
		shift_multiplication: [number, number][];
		multiplication: [number, number][];
		shift_division: [number, number][];
		dec2hex: number[];
		hex2dec: number[];
	};
</script>

<svelte:head>
	<script
		async
		src="https://analytics.eu.umami.is/script.js"
		data-website-id="e99cbf71-f7c3-4e75-9949-da2930855cb6"
	></script>

	<title>Exercices représentation de l'information</title>

	<meta
		name="description"
		content="Exercices générés automatiquement de calculs et conversions binaires"
	/>
</svelte:head>

<div id="content" class="container pt-4">
	<h1>Exercices représentation de l'information</h1>
	<p>Passer le doigt ou la souris sur la ligne d'un exercice pour voir la solution</p>
	<br />

	<h5>1. Convertir les nombres décimaux vers le binaire</h5>
	Utiliser la grille de conversion décimal-binaire
	<ul class="list-group list-group-flush w-50 offset-1">
		{#each data.dec2bin as n}
			<li class="list-group-item text-end" use:tooltip={{ content: bin(n), position: 'right' }}>
				{n}
			</li>
		{/each}
	</ul>

	<br />
	<h5>2. Convertir les nombres binaires vers le décimal</h5>
	Utiliser la grille de conversion décimal-binaire
	<ul class="list-group list-group-flush w-50 offset-1">
		{#each data.bin2dec as n}
			<li class="list-group-item text-end" use:tooltip={{ content: n, position: 'right' }}>
				{bin(n)}
			</li>
		{/each}
	</ul>

	<br />
	<h5>3. Effectuer les additions binaires en colonnes</h5>
	Vérifier les calculs en passant par le décimal
	<ul class="list-group list-group-flush w-50 offset-1">
		{#each data.addition as [a, b]}
			<li class="list-group-item text-end" use:tooltip={{ content: bin(a + b), position: 'right' }}>
				{bin(a)} + {bin(b)}
			</li>
		{/each}
	</ul>

	<br />
	<h5>4. Effectuer les multiplications binaires par décalage de bits</h5>
	Vérifier les calculs en passant par le décimal (à moins que le résultat ne soit trop grand)
	<ul class="list-group list-group-flush w-50 offset-1">
		{#each data.shift_multiplication as [a, b]}
			<li class="list-group-item text-end" use:tooltip={{ content: bin(a * b), position: 'right' }}>
				{bin(a)} x {b}
			</li>
		{/each}
	</ul>

	<br />
	<h5>5. Effectuer les multiplications binaires en colonnes</h5>
	Vérifier les calculs en passant par le décimal (à moins que le résultat ne soit trop grand)
	<ul class="list-group list-group-flush w-50 offset-1">
		{#each data.multiplication as [a, b]}
			<li class="list-group-item text-end" use:tooltip={{ content: bin(a * b), position: 'right' }}>
				{bin(a)} x {bin(b)}
			</li>
		{/each}
	</ul>

	<br />
	<h5>6. Effectuer les divisions binaires entières par décalage de bits</h5>
	Vérifier les calculs en passant par le décimal
	<ul class="list-group list-group-flush w-50 offset-1">
		{#each data.shift_division as [a, b]}
			<li
				class="list-group-item text-end"
				use:tooltip={{ content: bin(Math.floor(a / b)), position: 'right' }}
			>
				{bin(a)} / {b}
			</li>
		{/each}
	</ul>

	<br />
	<h5>7. Convertir les nombres décimaux vers l'hexadécimal</h5>
	<ul class="list-group list-group-flush w-50 offset-1">
		{#each data.dec2hex as n}
			<li class="list-group-item text-end" use:tooltip={{ content: hex(n), position: 'right' }}>
				{n}
			</li>
		{/each}
	</ul>

	<br />
	<h5>8. Convertir les nombres hexadécimaux vers le décimal</h5>
	<ul class="list-group list-group-flush w-50 offset-1">
		{#each data.hex2dec as n}
			<li class="list-group-item text-end" use:tooltip={{ content: n, position: 'right' }}>
				{hex(n)}
			</li>
		{/each}
	</ul>

	<br />
	<br />
</div>

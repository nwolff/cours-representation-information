import type { Load } from '@sveltejs/kit';

import { Random } from 'random-js';

import { range, zip2 } from '$lib/helpers';

const r = new Random();

export const load: Load = async () => {
	return makeExercices(r);
};

function makeExercices(r: Random): {
	dec2bin: number[];
	bin2dec: number[];
	addition: [number, number][];
	shift_multiplication: [number, number][];
	multiplication: [number, number][];
	shift_division: [number, number][];
	dec2hex: number[];
	hex2dec: number[];
} {
	const XXS = range(3, 5);
	const XS = range(5, 8);
	const S = range(8, 16);
	const M = range(16, 128);
	const L = range(128, 256);
	const XL = range(256, 512);

	function conversionNumbers(): number[] {
		return [r.pick(S), r.pick(L), r.pick(XL)];
	}

	function addition(): [number, number][] {
		const pairs = [
			[S, M],
			[M, L],
			[L, M]
		];
		return pairs.map(([a, b]) => [r.pick(a), r.pick(b)]);
	}

	function shiftMultiplication(): [number, number][] {
		const numbers = [0b111, 0b1111111, 0b111100];
		const pows = [2, 4, 8];
		r.shuffle(pows);
		return zip2(numbers, pows);
	}

	function multiplication(): [number, number][] {
		const pairs = [
			[S, XS],
			[M, XS],
			[XXS, XL]
		];
		return pairs.map(([a, b]) => [r.pick(a), r.pick(b)]);
	}

	function shiftDivision(): [number, number][] {
		const numbers = [0b101, 0b1010101, 0b11110000];
		const pows = r.sample([2, 4, 8, 16, 32], 3);
		return zip2(numbers, pows);
	}

	return {
		dec2bin: conversionNumbers(),
		bin2dec: conversionNumbers(),
		addition: addition(),
		shift_multiplication: shiftMultiplication(),
		multiplication: multiplication(),
		shift_division: shiftDivision(),
		dec2hex: conversionNumbers(),
		hex2dec: conversionNumbers()
	};
}

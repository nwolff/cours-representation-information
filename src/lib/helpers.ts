export function range(from: number, to: number): number[] {
	return Array.from({ length: to - from }, (_, i) => i + from);
}

export function zip2<A, B>(as: A[], bs: B[]): [A, B][] {
	const minLen = Math.min(as.length, bs.length);
	return as.slice(0, minLen).map((a, i) => [a, bs[i]]);
}

export function zip3<A, B, C>(as: A[], bs: B[], cs: C[]): [A, B, C][] {
	const minLen = Math.min(as.length, bs.length, cs.length);
	return as.slice(0, minLen).map((a, i) => [a, bs[i], cs[i]]);
}

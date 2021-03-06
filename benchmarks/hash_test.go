package benchmarks

import (
	"fmt"
	"math/rand"
	"runtime"
	"runtime/debug"
	"testing"
)

/*
BenchmarkAccessStructure show compare metrics between data strucuture and number of items.
*/
func BenchmarkAccessStructure(b *testing.B) {
	debug.SetGCPercent(-1)
	for _, size := range []int{1, 10, 100, 1000, 10000, 100000, 1000000} {
		benchmarkAccessStructure(b, size)
		runtime.GC()
	}
}

func benchmarkAccessStructure(b *testing.B, size int) {
	var indexes = make([]int, size, size)
	var arr = make([]int, size, size)
	var hash = make(map[int]int)

	rand.Seed(int64(size % 42))
	for i := 0; i < size; i++ {
		indexes[i] = rand.Intn(size)
		arr[i] = i
		hash[i] = i
	}

	b.ResetTimer()

	b.Run(fmt.Sprintf("Array_%d", size), func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			indx := indexes[i%size] % size
			_ = arr[indx]
		}
	})

	b.Run(fmt.Sprintf("Hash_%d", size), func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			indx := indexes[i%size] % size
			_ = hash[indx]
		}
	})
}

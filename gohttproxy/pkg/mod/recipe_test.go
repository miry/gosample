package mod_test

import (
	"testing"

	"github.com/miry/samples/gohttproxy/pkg/mod"
	"github.com/stretchr/testify/assert"
)

func TestRecipeContent(t *testing.T) {
	subject := mod.Recipe{}
	assert.Equal(t, 0, len(subject.Content), "should be empty")
}

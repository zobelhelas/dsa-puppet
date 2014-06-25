class apache2::cache {
	apache2::module { 'expires': }
	apache2::module { 'rewrite': }
}


class Usuario {
	const contenidosVistos = #{}
	method vioCompleto(contenido) = contenido.vistoCompletoPor(self)
	
	method vio(contenido) = contenidosVistos.contains(contenido)
	
	method generosVistos() = 
		contenidosVistos.map {contenido => contenido.genero()}.asSet()
	
	method generoFavorito() = 
		self.generosVistos().max{ genero => self.minutosVistosDe(genero)}

	method minutosVistosDe(genero) =
		self.contenidosVistosDe(genero).sum {contenido => contenido.duracion() }
	
	method contenidosVistosDe(genero) =
		contenidosVistos.filter {contenido => contenido.genero() == genero}


}

class ContenidoUnitario{
	const property duracion
	method vistoCompletoPor(usuario) = usuario.vio(self)
}
class Pelicula inherits ContenidoUnitario{
	const property genero
	const actores
	
	method aparece(actor) = actores.contains(actor)	
}
class Capitulo inherits ContenidoUnitario{
	const property numero
	const temporada
	const actoresInvitados = #{}
	
	method aparece(actor) = self.actores().contains(actor)
	method actores() = actoresInvitados.union(temporada.protagonistas()) 
	method genero() = temporada.genero()
}

class ContenidoCompuesto{
		
	method componentes()
	
	method vistoCompletoPor(usuario) = self.componentes().all 
		{componente => usuario.vioCompleto(componente)}

	method duracion() = self.componentes().sum
		{componente => componente.duracion()}
	
	
}
class Serie inherits ContenidoCompuesto{
	const temporadas
	const property genero
	const property protagonistas
	
	override method componentes() = temporadas
	
	method ultimoCapitulo() = temporadas.last().ultimoCapitulo()

}
	
class Temporada inherits ContenidoCompuesto{
	const capitulos
	const serie
	
	method genero() = serie.genero()
	
	override method componentes() = capitulos
	
	method ultimoCapitulo() = capitulos.max
		{capitulo => capitulo.numero()}
		
	method protagonistas() = serie.protagonistas()
}

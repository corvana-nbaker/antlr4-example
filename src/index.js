import { CommonTokenStream, InputStream } from 'antlr4'
import { QueryLexer, QueryParser } from '@corvana/query-engine-parsers'

let formula = 'foo("bar")'
let iterations = []
for(let i=0; i<10; i++){
    let start = new Date().getTime()
    formula = 'iter' + i + '(' + formula + ')'
    const is = new InputStream(formula)
    const lexer = new QueryLexer.QueryLexer(is)
    const tokens = new CommonTokenStream(lexer)
    const parser = new QueryParser.QueryParser(tokens)
    parser.buildParseTrees = false

    parser.expression()
    let end = new Date().getTime()
    iterations.push({time_in_millis: (end - start)})
}
console.table(iterations)



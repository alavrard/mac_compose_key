require "json"

KEYSTROKES = {
	%{'e}  => {result: "é", upcase: true },

	%{6a}  => {result: "â", upcase: true },
	%{6e}  => {result: "ê", upcase: true },
	%{6i}  => {result: "î", upcase: true },
	%{6o}  => {result: "ô", upcase: true },
	%{6u}  => {result: "û", upcase: true },
	%{^a}  => {result: "â", upcase: true },
	%{^e}  => {result: "ê", upcase: true },
	%{^i}  => {result: "î", upcase: true },
	%{^o}  => {result: "ô", upcase: true },
	%{^u}  => {result: "û", upcase: true },

	%{`a}  => {result: "à", upcase: true },
	%{`e}  => {result: "è", upcase: true },
	%{`i}  => {result: "ì", upcase: true },
	%{`o}  => {result: "ò", upcase: true },
	%{`u}  => {result: "ù", upcase: true },

	%{"a}  => {result: "ä", upcase: true },
	%{"e}  => {result: "ë", upcase: true },
	%{"i}  => {result: "ï", upcase: true },
	%{"o}  => {result: "ö", upcase: true },
	%{"u}  => {result: "ü", upcase: true },

	%{=e}  => {result: "€", upcase: false },
	%{=/}  => {result: "≠", upcase: false },
	%{=c}  => {result: "€", upcase: false },

	%{`n}  => {result: "ñ", upcase: true },
	%{~n}  => {result: "ñ", upcase: true },

	%{,c}  => {result: "ç", upcase: true },

	%{ae}  => {result: "æ", upcase: true },
	%{oe}  => {result: "œ", upcase: true },
	%{o/}  => {result: "ø", upcase: true },
	%{or}  => {result: "®", upcase: false },
	%{oc}  => {result: "©", upcase: false },

	%{ss}  => {result: "ß", upcase: false },
	%{...} => {result: "…", upcase: false },
}

def iterate(keys, result, h)
	k = keys.shift

	if keys.size > 0
		j = h[k] || {}
		h[k] ||= j
		iterate(keys, result, j)
	else
		h[k] = result
	end
end

$data = {}

def add_keystrokes(keys, result)
	keys.each do |k|
		iterate(k, result, $data)
	end
end

KEYSTROKES.each do |keys, output|
	if output[:upcase]
		add_keystrokes(keys.downcase.split("").permutation(keys.size).to_a, output[:result].downcase)
		add_keystrokes(keys.upcase.split("").permutation(keys.size).to_a, output[:result].upcase)
	else
		add_keystrokes(keys.split("").permutation(keys.size).to_a, output[:result])
	end
end

$h = []

def print_dict(data)
	data.map do |k, v|
		if k == '"'
			k = '\"'
		end

		if k == '~'
			k = '\\\\\~'
		end

		if v.is_a?(Hash)
			<<~EOF
				"#{k}" = {
				  #{print_dict(v)}
				};
			EOF
		else
			%{"#{k}" = ("insertText:", "#{v}");}
		end
	end.join("\n")
end

h = {}
h['\UF710'] = $data
puts print_dict(h)
